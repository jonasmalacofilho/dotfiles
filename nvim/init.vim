" Essential behavior
set ignorecase smartcase   " ignore case in all-lowercase patterns
set mouse=nvi              " enable mouse support on selected modes
set nomodeline             " don't honor vim modelines in files
set splitbelow splitright  " threat splits as auxiliary
set autowrite              " write the buffer before :make, :! and others
if !has('nvim')
	" not exhaustive, just the absolute bare minimum
	set encoding=utf-8  " ensure sane encoding
	set nocompatible    " don't break vim for vi
	set noexrc          " don't source rc files in current directory
	" to make this configuration properly usable on vim:
	" - check `:h vim-differences` in nvim
	" - check my old `~/.vim`
	" - check vim-sensible by Tim Pope
endif


" Appearance is less important than behvior, but these are essentials too
colorscheme desert
set colorcolumn=80,100           " highlight 80 and 100 column thresholds
set cursorline                   " make it easier to find where the cursor is
set list                         " show tabs, trailling space and nbsp
set relativenumber number        " use relative numbers on all but current line
set scrolloff=3 sidescrolloff=3  " ensure there's always some context visible
set termguicolors                " use 24-bit colors
set title                        " filename on window title


call plug#begin('~/.config/nvim/plugged')
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
call plug#end()

" Utilities that overload or extend existing Vim features
nnoremap Y y$      |" yank from cursor to EOL, like C and D
nnoremap gV `[v`]  |" select text that was just pasted
vnoremap < <gv     |" restore visual mode after indenting
vnoremap > >gv     |" restore visual mode after indenting


" Leader space
let mapleader = "\<Space>"
nnoremap <Leader>b :b#<CR>
nnoremap <Leader>l :nohlsearch<CR>
nnoremap <Leader>w :w<CR>
" + common build targets (assumes makeprg has been set by plugin or user)
nnoremap <Leader>0 :make clean<CR>
nnoremap <Leader>k :make check<CR>
nnoremap <Leader>m :make<CR>
nnoremap <Leader>o :make doc<CR>
nnoremap <Leader>u :make build<CR>
nnoremap <Leader>y :make test<CR>
if has('nvim')
	nnoremap <Leader>` :source ~/.config/nvim/init.vim<CR>
else
	nnoremap <Leader>` :source ~/.config/nvim/init.vim<CR>
endif
" + [r]ust (assumes rust.vim)
autocmd FileType rust nnoremap <Leader>Y :RustTest<CR>
autocmd FileType rust nnoremap <Leader>O :make doc --open<CR>


" TO-DO list
" - comments (tcomment?)
" - file explorer (ranger.vim?)
" - language server (nvim-lsp)
" - rust (rust.vim + rls)
" - haxe (vaxe? lsp client?)
" - decent colorscheme
" - jumping into files (CtrlP?)
" - other useful features or plugins from the old setup
" - use ripgrep in :grep


" Left out for now
" set autowrite
" noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
" noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
