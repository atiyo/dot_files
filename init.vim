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
"line width markers
set colorcolumn=80
set textwidth=80
set foldmethod=indent
set relativenumber

"help identify julia files
au VimEnter,BufRead,BufNewFile *.jl set filetype=julia
"help identify racket files
au VimEnter,BufRead,BufNewFile *.rkt set filetype=racket
filetype plugin indent on
au Filetype python,haskell,julia setlocal omnifunc=v:lua.vim.lsp.omnifunc

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
" quit shortcut
nnoremap <silent> <Leader>q :q<CR>
" split window
nnoremap <silent> <Leader>v :vsplit<CR>
" R piping shortcut
au VimEnter,BufRead,BufNewFile *.[r|R] inoremap <C-\> %>%


call plug#begin('~/.nvim/plugged')
    "LSP settings
    Plug 'neovim/nvim-lspconfig'
    ""Completion
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
    "Buffers as tabs
    Plug 'ap/vim-buftabline'
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
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    "Seamless tmux/window navigation
    Plug 'christoomey/vim-tmux-navigator'
    "More versatile dots
    Plug 'tpope/vim-repeat'
    "J Syntax highlighting
    Plug 'guersam/vim-j'
    "Easy alignment
    Plug 'junegunn/vim-easy-align'
    "Latex
    Plug 'lervag/vimtex'
    "Snippet engine
    Plug 'SirVer/ultisnips'
    "Snippet collection
    Plug 'honza/vim-snippets'
call plug#end()


lua << EOF
require'lspconfig'.pyls.setup{}
require'lspconfig'.ghcide.setup{}
require'lspconfig'.solargraph.setup{}
require'lspconfig'.julials.setup{}
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = true,
    update_in_insert = false,
  }
)
EOF


nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K  <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> ]d <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> [d <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>


let g:deoplete#enable_at_startup = 1
set completeopt-=preview

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"


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
vnoremap <Space> :TREPLSendSelection<CR>
nnoremap <C-Space> :TREPLSendFile<CR>
nnoremap <Leader>t :vertical Tnew<CR>
nnoremap <Leader>c :Tclear<CR>
vnoremap <Leader>s :s/self.//g<CR>
tnoremap <Esc> <C-\><C-n>


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
nnoremap <Leader>/ :Rg<CR>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"Colour scheme config
syntax enable
set background=dark
colorscheme gruvbox

"Buffer navigation
nnoremap <C-m> :bnext<CR>
nnoremap <C-n> :bprev<CR>

"Status line config
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ }

let g:tex_flavor = 'latex'
let g:vimtex_compiler_latexmk = { 
        \ 'executable' : 'latexmk',
        \ 'options' : [ 
        \   '-xelatex',
        \   '-file-line-error',
        \   '-synctex=1',
        \   '-interaction=nonstopmode',
        \ ],
        \}


let g:UltiSnipsExpandTrigger="<C-h>"
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-k>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

let g:latex_to_unicode_tab=0
let g:latex_to_unicode_auto=1
