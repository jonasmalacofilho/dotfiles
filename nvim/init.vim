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


" Load plugins
call plug#begin('~/.config/nvim/plugged')
	Plug 'rust-lang/rust.vim', { 'for': 'rust' }
	Plug 'tpope/vim-commentary'

	if executable('ranger')
		" file explorer that supports Miller Columns
		let g:ranger_map_keys = 0
		let g:ranger_replace_netrw = 1
		if has('nvim')
			let g:bclose_no_plugin_maps = 0
			Plug 'rbgrouleff/bclose.vim'
		endif
		Plug 'francoiscabrol/ranger.vim'
	else
		" noop, just use netrw like a savage
	endif
call plug#end()


" Utilities that overload or extend existing Vim features
nnoremap Y y$      |" yank from cursor to EOL, like C and D
nnoremap gV `[v`]  |" select text that was just pasted
vnoremap < <gv     |" restore visual mode after indenting
vnoremap > >gv     |" restore visual mode after indenting


" Leader space
let mapleader = "\<Space>"
map <Leader>c :Commentary<CR>
nmap <Leader>b :b#<CR>
nmap <Leader>f :Ranger<CR>
nmap <Leader>l :nohlsearch<CR>
nmap <Leader>q :q<CR>
nmap <Leader>s :sp<CR>
nmap <Leader>t :tabe<CR>
nmap <Leader>v :vsp<CR>
nmap <Leader>w :w<CR>
" common :[m]ake build targets
nmap <Leader>m0 :make clean<CR>
nmap <Leader>mc :make check<CR>
nmap <Leader>md :make doc<CR>
nmap <Leader>mm :make<CR>
nmap <Leader>mt :make test<CR>
if has('nvim')
	nmap <Leader>` :source ~/.config/nvim/init.vim<CR>
else
	nmap <Leader>` :source ~/.config/nvim/init.vim<CR>
endif
" rust (assumes rust.vim)
" (note: building from Cargo.toml is currently broken)
autocmd FileType rust nmap <Leader>mD :make doc --open<CR>
autocmd FileType rust nmap <Leader>mT :RustTest<CR>
autocmd FileType rust nmap <Leader>mm :make build<CR>


" TO-DO list
" - lsp server (nvim-lsp, vim-lsp, coc-vim?)
" - rust lsp client (rust-analyzer)
" - haxe (vaxe, hls?)
" - decent colorscheme
" - jumping into files (CtrlP?)
" - other useful features or plugins from the old setup
" - use ripgrep in :grep


" Left out for now
" set autowrite
" noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
" noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
