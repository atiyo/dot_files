"""general options
"do not insist on vi compatibility
set nocompatible
"use system clipboard
set clipboard=unnamed
"keep swap files out of the way
set backupdir=~/.vim/tmp/
set directory=~/.vim/tmp/
"line number
set number 
"cursorlin
set cursorline 
"make backspace respect end of lines
set backspace=indent,eol,start
"tabs are 4 spaces
set tabstop=4 
set softtabstop=4
set expandtab
set shiftwidth=4    
"hide buffers instead of closing them
set hidden
"intuitive splits
set splitbelow
set splitright

set colorcolumn=80
set textwidth=80

filetype plugin indent on
"help identify julia files
au VimEnter,BufRead,BufNewFile *.jl set filetype=julia
"help identify racket files
au VimEnter,BufRead,BufNewFile *.rkt set filetype=racket
"while using r, provide shortcut for piping
au FileType r inoremap <silent> <C-l> %>%

" A little helper function to help maintain the markdown previewer
function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release
    else
      !cargo build --release --no-default-features --features json-rpc
    endif
  endif
endfunction

" With a nod to https://vi.stackexchange.com/questions/454/whats-the-simplest-way-to-strip-trailing-whitespace-from-all-lines-in-a-file
function! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfunction

function! ToggleLineLength()
    if &colorcolumn==80
        set colorcolumn=120
        set textwidth=120
    else
        set colorcolumn=80
        set textwidth=80
    endif
endfunction

"establish leader key
nmap \\ <Leader>
" trim trailing white spaces in the file
noremap <Leader>s :call TrimWhitespace()<CR>

"Resize windows nicely
nnoremap = :vertical resize +5<CR>
nnoremap - :vertical resize -5<CR>
nnoremap + :res +5<CR>
nnoremap _ :res -5<CR>
"remove highlighting from searches
nnoremap <silent> <Esc> :noh<CR>
"close all windows except the current
nnoremap <silent> <Leader>o :only<CR>
"navigate buffers
"list buffer
nnoremap <silent> <Leader>b :Buffers<CR>
"delete buffer, retain window
nnoremap <silent> <Leader>d :bp\|bd #<CR>
"close buffer and window
nnoremap <silent> <Leader>w :bd<CR>
"next buffer
nnoremap <silent> <Leader>. :bn<CR>
"previous buffer
nnoremap <silent> <Leader>, :bp<CR>
" quit shortcut
nnoremap <silent> <Leader>q :q<CR>
" R piping shortcut
inoremap <C-\> %>%

call plug#begin('~/.nvim/plugged')
    "LSP
    Plug 'autozimu/LanguageClient-neovim', {
        \ 'branch': 'next',
        \ 'do': 'bash install.sh',
        \ }
    "Autocompletion
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    "Change surroundings
    Plug 'tpope/vim-surround'
    "File Browser
    Plug 'scrooloose/nerdtree'
    "Easy commenting
    Plug 'scrooloose/nerdcommenter'
    "Colors!
    Plug 'morhetz/gruvbox'
    "Status line
    Plug 'itchyny/lightline.vim'
    "Buffers in status line
    Plug 'vim-scripts/buftabs'
    "Terminal in vim
    Plug 'kassio/neoterm'
    "Git from vim
    Plug 'tpope/vim-fugitive'
    "Markdown Preview
    Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
    "Julia syntax highlighting
    Plug 'JuliaEditorSupport/julia-vim'
    "Fuzzy finding
    Plug '/usr/local/opt/fzf'
    Plug 'junegunn/fzf.vim'
    "Seamless tmux/window navigation
    Plug 'christoomey/vim-tmux-navigator'
    "Lispy goodies
    Plug 'wlangstroth/vim-racket'
    "Highlighting for f and t movements
    Plug 'unblevable/quick-scope'
call plug#end()

"LSP Config
let g:LanguageClient_serverCommands = {
    \ 'python': ['python', '-m', 'pyls'],
    \ 'r': ['R', '--slave', '-e', 'languageserver::run()'],
    \ 'julia': ['julia', '~/.config/nvim/julia_lsp.jl'],
    \ 'cpp': ['/usr/local/Cellar/llvm/9.0.1/bin/clangd'],
    \ 'c': ['/usr/local/Cellar/llvm/9.0.1/bin/clangd'],
    \ 'haskell': ['hie-wrapper'],
    \ }

nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <Leader>l :call LanguageClient_contextMenu()<CR>
let g:LanguageClient_useVirtualText = 0

"navigate windows with tmux-navigator
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <C-h> :TmuxNavigateLeft<CR>
nnoremap <silent> <C-j> :TmuxNavigateDown<CR>
nnoremap <silent> <C-k> :TmuxNavigateUp<CR>
nnoremap <silent> <C-l> :TmuxNavigateRight<CR>

tnoremap <silent> <C-h> <C-\><C-n>:TmuxNavigateLeft<CR>
tnoremap <silent> <C-j> <C-\><C-n>:TmuxNavigateDown<CR>
tnoremap <silent> <C-k> <C-\><C-n>:TmuxNavigateUp<CR>
tnoremap <silent> <C-l> <C-\><C-n>:TmuxNavigateRight<CR>

"enter insert mode when changing to a terminal
autocmd WinEnter *
 \ if &buftype ==# 'terminal' |
 \  startinsert |
 \ endif
let g:lightline = {'colorscheme': 'gruvbox'}

"REPL Config
nnoremap <Space> :TREPLSendLine<CR>j
vnoremap <Space> :TREPLSendSelection<CR>}
nnoremap <C-Space> :TREPLSendFile<CR>
nnoremap <Leader>t :vertical Tnew<CR>
nnoremap <Leader>c :Tclear<CR>
tnoremap <Esc> <C-\><C-n>

"Autocomplete config
call deoplete#custom#option('num_processes', 1)
let g:deoplete#enable_at_startup = 1
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"

"Filebrowser config
nnoremap <Leader>n :NERDTreeToggle<CR>

" Git config
" These are pretty verbose. The way to remember them is to
" start with <Leader>g, then pretend you're typing the regular
" git command.
nnoremap <Leader>gad :Git add %:p<CR><CR>
nnoremap <Leader>gst :Gstatus<CR>
nnoremap <Leader>gco :Gcommit -v -q<CR>
nnoremap <Leader>gdi :Gdiff<CR>
nnoremap <Leader>gbr :Git branch<Space>
nnoremap <Leader>gch :Git checkout<Space>
nnoremap <Leader>gbl :Git blame<CR>
nnoremap <Leader>gpus :Git push<CR>
nnoremap <Leader>gpul :Git pull<CR>
" Exception to above rule. gme for merge conflicts.
nnoremap <Leader>gme :Gvdiffsplit!<CR>
" Arrows to point to which buffer you want to get from.
nnoremap <Leader>g, :diffget //2<CR>
nnoremap <Leader>g. :diffget //3<CR>

" FZF
" fuzzy find files
nnoremap <Leader>f :Files<CR>
" fuzzy grep
nnoremap <Leader>g :Rg<CR>

"Colour scheme config
syntax enable
set background=dark
colorscheme gruvbox


"Status line config
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ }
