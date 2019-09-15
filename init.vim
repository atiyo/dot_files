"""general options
"use bash
set shell=/bin/bash
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

filetype plugin indent on
"help identify julia files
au VimEnter,BufRead,BufNewFile *.jl set filetype=julia
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

"establish leader key
nmap \\ <Leader>
"remove highlighting from searches
nnoremap <silent> <Esc> :noh<Cr>
"close all windows except the current
nnoremap <silent> <Leader>o :only<CR>
"navigate buffers
nnoremap <silent> <Leader>b :ls<CR>
nnoremap <silent> <Leader>d :bd<CR>
nnoremap <silent> <Leader>. :bn<CR>
nnoremap <silent> <Leader>, :bp<CR>
nnoremap <silent> <Leader>1 :b1<CR>
nnoremap <silent> <Leader>2 :b2<CR>
nnoremap <silent> <Leader>3 :b3<CR>
nnoremap <silent> <Leader>4 :b4<CR>
nnoremap <silent> <Leader>5 :b5<CR>
nnoremap <silent> <Leader>6 :b6<CR>
nnoremap <silent> <Leader>7 :b7<CR>
nnoremap <silent> <Leader>8 :b8<CR>
nnoremap <silent> <Leader>9 :b9<CR>
nnoremap <silent> <Leader>0 :b10<CR>

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
    "Statusline
    Plug 'itchyny/lightline.vim'
    "REPL helper
    Plug 'epeli/slimux'
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
    "Rainbow parentheses
    Plug 'kien/rainbow_parentheses.vim'
    "Racket syntax etc.
    Plug 'wlangstroth/vim-racket'
    
call plug#end()

"LSP Config
let g:LanguageClient_serverCommands = {
    \ 'python': ['python', '-m', 'pyls'],
    \ 'r': ['R', '--slave', '-e', 'languageserver::run()'],
    \ 'julia': ['julia', '~/.config/nvim/julia_lsp.jl'],
    \ 'c': ['clangd'],
    \ 'haskell': ['hie-wrapper'],
    \ }

nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>:sleep50m<CR><C-w><S-H>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <Leader>l :call LanguageClient_contextMenu()<CR>

"navigate windows with tmux-navigator
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
nnoremap <silent> <C-l> :TmuxNavigateRight<cr>

"REPL Config
nmap <Space> :SlimuxREPLSendLine<CR>j
vnoremap <Space> :SlimuxREPLSendSelection<CR>
let g:slimux_select_from_current_window = 1
let g:slime_target = 'tmux'

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
nnoremap <Leader>gme :Git merge<CR>
nnoremap <Leader>gpus :Git push<CR>
nnoremap <Leader>gpul :Git pull<CR>

" FZF
" fuzzy find files
nnoremap <Leader>ff :Files<CR>
" fuzzy grep
nnoremap <Leader>fg :Rg<CR>

"Colour scheme config
syntax enable
set background=dark
colorscheme gruvbox
let g:lightline = {'colorscheme': 'gruvbox'}
