" Essential behavior
set ignorecase smartcase   " ignore case in all-lowercase patterns
set mouse=nvi              " enable mouse support on selected modes
set nomodeline             " don't honor vim modelines in files
set splitbelow splitright  " threat splits as auxiliary
set autowrite              " write the buffer before :make, :! and others
if !has('nvim')
  " ensure bare minimum sanity/security in vim
  set encoding=utf-8  " ensure sane encoding
  set nocompatible    " don't break vim for vi
  set noexrc          " don't source rc files in current directory
  " to make this configuration properly usable on vim:
  " - check `:h vim-differences` in nvim
  " - check vim-sensible by Tim Pope
endif


" Appearance is less important than behvior, but these are essentials too
colorscheme default              " (temporary)
set colorcolumn=80,100           " highlight 80 and 100 column thresholds
set cursorline                   " make it easier to find where the cursor is
set list                         " show tabs, trailling space and nbsp
set relativenumber number        " use relative numbers on all but current line
set scrolloff=3 sidescrolloff=3  " ensure there's always some context visible
set notermguicolors              " DON'T use 24-bit colors (temporary)
set title                        " filename on window title


" Load plugins
call plug#begin('~/.config/nvim/plugged')
  Plug 'mattn/vim-lsp-settings'
  Plug 'prabirshrestha/vim-lsp'
  Plug 'rust-lang/rust.vim', { 'for': 'rust' }
  Plug 'tpope/vim-commentary'

  if executable('ranger')
    " file explorer that supports Miller Columns
    let g:ranger_map_keys = 0  " let me do this myself
    let g:ranger_replace_netrw = 1
    if has('nvim')
      " ranger.vim uses bclose.vim on neovim
      let g:bclose_no_plugin_maps = 1  " important: conflicts with my mappings
      Plug 'rbgrouleff/bclose.vim'
    endif
    Plug 'francoiscabrol/ranger.vim'
  else
    " noop, just use netrw like a savage
  endif

  " under evaluation:
call plug#end()


" Language server protocol client
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc')
    setlocal tagfunc=lsp#tagfunc
  endif
  nmap <buffer> gd <Plug>(lsp-definition)
  nmap <buffer> gr <Plug>(lsp-references)
  nmap <buffer> gi <Plug>(lsp-implementation)
  nmap <buffer> gt <Plug>(lsp-type-definition)
  nmap <buffer> <leader>rn <Plug>(lsp-rename)
  nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
  nmap <buffer> K <Plug>(lsp-hover)
endfunction
augroup LspInstall
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END


" Utilities that overload or extend existing Vim features
nnoremap Y y$      |" yank from cursor to EOL, like C and D
nnoremap gV `[v`]  |" select text that was just pasted
vnoremap < <gv     |" restore visual mode after indenting
vnoremap > >gv     |" restore visual mode after indenting


" FileType-dependent indentation
autocmd FileType vim set expandtab shiftwidth=2


" Toplevel <Leader> space
let mapleader = "\<Space>"
map <Leader>o :Commentary<CR>
nmap <Leader>b :b#<CR>
nmap <Leader>f :Ranger<CR>
nmap <Leader>l :nohlsearch<CR>
nmap <Leader>q :q<CR>
nmap <Leader>s :sp<CR>
nmap <Leader>t :tabe<CR>
nmap <Leader>v :vsp<CR>
nmap <Leader>w :w<CR>
nmap <Leader>x :x<CR>
if has('nvim')
  nmap <Leader>` :source ~/.config/nvim/init.vim<CR>
else
  nmap <Leader>` :source ~/.vim/vimrc<CR>
endif


" <Leader> [m]ake space
nmap <Leader>m0 :make clean<CR>
nmap <Leader>mc :make check<CR>
nmap <Leader>md :make doc<CR>
nmap <Leader>mm :make<CR>
nmap <Leader>mt :make test<CR>
autocmd FileType rust nmap <Leader>mD :make doc --open<CR>
autocmd FileType rust nmap <Leader>mT :RustTest<CR>
autocmd FileType rust nmap <Leader>mm :make build<CR>
" note: building from Cargo.toml is currently broken


" TO-DO list
" - haxe (vaxe, hls?)
" - decent colorscheme
" - jumping into files (CtrlP?)
" - other useful features or plugins from the old setup
" - use ripgrep in :grep
" - spell checking
" - window size/placement shortcuts (2/3? center, only)
" - auto breaklines in certain formats (markdown? git?)


" Left out for now
" noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
" noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
