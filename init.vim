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
set colorcolumn=100
set textwidth=100
autocmd FileType tex set colorcolumn=120
autocmd FileType tex set textwidth=120
set foldmethod=indent
set relativenumber

"help identify julia files
au VimEnter,BufRead,BufNewFile *.jl set filetype=julia
filetype plugin indent on

" With a nod to https://vi.stackexchange.com/questions/454/whats-the-simplest-way-to-strip-trailing-whitespace-from-all-lines-in-a-file
function! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
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
nnoremap <silent> i :noh<CR>i
nnoremap <silent> c :noh<CR>c
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
nnoremap <silent> <Leader>q :qa<CR>
nnoremap <silent> <Leader>x :xa<CR>
" split window
nnoremap <silent> <Leader>v :vsplit<CR>
" repeat macros with M
nnoremap <silent> M @@
" R piping shortcut
au VimEnter,BufRead,BufNewFile *.[r|R] inoremap <C-\> %>%
nnoremap <silent> <Leader>ls :write \| edit \| TSBufEnable highlight<CR>
"Easy rsyncing
nnoremap <Leader>ru :!rup<CR>
nnoremap <Leader>rd :!rdo<CR>

call plug#begin('~/.nvim/plugged')
    "LSP settings
    Plug 'neovim/nvim-lspconfig'
    ""Completion
    Plug 'hrsh7th/nvim-compe', { 'do': ':UpdateRemotePlugins' }
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
    "Julia syntax highlighting
    Plug 'JuliaEditorSupport/julia-vim'
    Plug 'kdheepak/JuliaFormatter.vim'
    "Fuzzy finding
    Plug '/usr/local/opt/fzf'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    ""Seamless tmux/window navigation
    Plug 'christoomey/vim-tmux-navigator'
    "More versatile dots
    Plug 'tpope/vim-repeat'
    "Easy alignment
    Plug 'junegunn/vim-easy-align'
    "Latex
    Plug 'lervag/vimtex'
    "Tree sitter
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'justinmk/vim-sneak'
call plug#end()


lua << EOF
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', 'rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.keymap.set('n', '<C-f>', function() vim.lsp.buf.format { async = true } end, bufopts)

  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

-- Use a loop to conveniently both setup defined servers
-- and map buffer local keybindings when the language server attaches
local servers = { "pylsp", "julials", "r_language_server", "hls"}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
-- Disable virtual text for diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = true,
    update_in_insert = false,
  }
)
EOF

autocmd FileType julia nnoremap <buffer> <C-f> :JuliaFormatterFormat<CR>
autocmd FileType julia vnoremap <buffer> <C-f> :JuliaFormatterFormat<CR>
autocmd FileType python nnoremap <buffer> <C-s> :Isort<CR>
autocmd FileType tex nnoremap <buffer> <C-f> :%! latexindent.pl -m<CR>
autocmd FileType json nnoremap <C-f> :%! jq .<CR>

set completeopt=menuone,noselect
let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.vsnip = v:true
let g:compe.source.ultisnips = v:true

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T
let g:sneak#label = 1

""navigate windows with tmux-navigator
"let g:tmux_navigator_no_mappings = 1
"nnoremap <silent> <C-h> :TmuxNavigateLeft<CR>
"nnoremap <silent> <C-j> :TmuxNavigateDown<CR>
"nnoremap <silent> <C-k> :TmuxNavigateUp<CR>
"nnoremap <silent> <C-l> :TmuxNavigateRight<CR>

nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-l> <C-w>l

tnoremap <silent> <C-h> <C-\><C-n><C-w>h
tnoremap <silent> <C-j> <C-\><C-n><C-w>j
tnoremap <silent> <C-k> <C-\><C-n><C-w>k
tnoremap <silent> <C-l> <C-\><C-n><C-w>l

"enter insert mode when changing to a terminal
autocmd WinEnter *
 \ if &buftype ==# 'terminal' |
 \  startinsert |
 \ endif
let g:lightline = {'colorscheme': 'gruvbox'}

"REPL Config
nnoremap <Space> :TREPLSendLine<CR>j
vnoremap <Space> :TREPLSendSelection<CR>
nnoremap <C-Space> vip :TREPLSendSelection<CR>}
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
nnoremap <Leader>gco :Git commit -v -q<CR>
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
colorscheme gruvbox

"Buffer navigation
nnoremap L :bnext<CR>
nnoremap H :bprev<CR>

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

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  -- Modules and its options go here
  highlight = { enable = true },
  incremental_selection = { enable = true },
  textobjects = { enable = true },
}
EOF


let g:latex_to_unicode_tab=0
let g:latex_to_unicode_auto=1
