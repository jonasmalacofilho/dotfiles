" Essential behavior
set autowrite              " write the buffer before :make, :! and others
set ignorecase smartcase   " ignore case in all-lowercase patterns
set mouse=nvi              " enable mouse support on selected modes
set nomodeline             " don't honor vim modelines in files
set spell spelllang=en_us  " spell by default (assumes undercurls are available)
set spellfile=~/.config/nvim/spell/personal.utf-8.add
set splitbelow splitright  " threat splits as auxiliary
set switchbuf=useopen,usetab  " reuse existing window or tab with target buffer
if !has('nvim')
  " ensure bare minimum sanity/security in vim
  set autoread        " don't work on outdate files
  set encoding=utf-8  " ensure sane encoding
  set nocompatible    " don't break vim for vi
  set noexrc          " don't source rc files in current directory
  " to make this configuration properly usable on vim:
  " - check `:h vim-differences` in nvim
  " - check vim-sensible by Tim Pope
endif


" Appearance is less important than behavior, but these are essentials too
set colorcolumn=80,100           " highlight 80 and 100 column thresholds
set cursorline                   " make it easier to find where the cursor is
set list                         " show tabs, trailing space and nbsp
set relativenumber number        " use relative numbers on all but current line
set scrolloff=3 sidescrolloff=3  " ensure there's always some context visible
set signcolumn=yes               " avoid distracting popping of the sign column
set termguicolors                " enable 24-bit color
set title                        " filename on window title


" Load plugins
call plug#begin('~/.config/nvim/plugged')
  Plug 'rust-lang/rust.vim', { 'for': 'rust' }
  Plug 'tpope/vim-commentary'

  if executable('rg')
    " use ripgrep to skip vcs and ignored files, if available
    let g:ctrlp_user_command = 'rg --files %s'
  endif
  let g:ctrlp_working_path_mode = 'a'  " start from cwd or this files' directory
  Plug 'ctrlpvim/ctrlp.vim'

  let g:lsp_signs_error = {'text': '✗'}
  let g:lsp_signs_hint = {'text': '✎'}
  let g:lsp_signs_information = {'text': 'ℹ'}
  let g:lsp_signs_warning = {'text': '⚠'}
  let g:lsp_virtual_text_prefix = 'ᐊ '
  Plug 'mattn/vim-lsp-settings'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/vim-lsp'

  let g:gruvbox_italic = 1
  let g:gruvbox_sign_column = 'bg0'
  Plug 'jonasmalacofilho/gruvbox'  " upstream is morhetz/gruvbox
  autocmd VimEnter * colorscheme gruvbox

  if executable('ranger')
    " use a file explorer that supports Miller Columns, if available
    let g:ranger_map_keys = 0  " let me do this myself
    let g:ranger_replace_netrw = 1
    if has('nvim')
      " ranger.vim uses bclose.vim on neovim
      let g:bclose_no_plugin_maps = 1  " important: conflicts with my mappings
      Plug 'rbgrouleff/bclose.vim'
    endif
    Plug 'francoiscabrol/ranger.vim'
  else
    " (no-op) otherwise just use netrw like a savage
  endif

  " under evaluation:
  " <empty>
call plug#end()


" Language server protocol client
function! s:on_lsp_buffer_enabled() abort
  nmap <Leader>rn <Plug>(lsp-rename)
  nmap K <Plug>(lsp-hover)
  nmap [g <Plug>(lsp-previous-diagnostic)
  nmap ]g <Plug>(lsp-next-diagnostic)
  nmap gd <Plug>(lsp-definition)

  " disable markdown syntax in lsp-hovers since rendering it is currently broken
  autocmd FileType markdown.lsp-hover setlocal filetype=text.lsp-hover

  " let g:lsp_highlight_references_enabled = 1  " distracting
  " nmap gi <Plug>(lsp-implementation)          " conflicts with Vim mappings
  " nmap gr <Plug>(lsp-references)              " conflicts with Vim mappings
  " nmap gt <Plug>(lsp-type-definition)         " conflicts with Vim mappings
endfunction
autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()


" Auto completion
imap <c-space> <Plug>(asyncomplete_force_refresh)
inoremap <expr> <C-E>   pumvisible() ? asyncomplete#cancel_popup() : "\<C-E>"
inoremap <expr> <CR>    pumvisible() ? "\<C-Y>\<cr>" : "\<CR>"
inoremap <expr> <ESC>   pumvisible() ? asyncomplete#cancel_popup() : "\<ESC>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-P>" : "\<S-Tab>"
inoremap <expr> <Tab>   pumvisible() ? "\<C-N>" : "\<Tab>"


" Utilities that overload or extend existing Vim features
nnoremap Y y$|      " yank from cursor to EOL, like C and D
nnoremap gV `[v`]|  " select text that was just pasted
vnoremap < <gv|     " restore visual mode after indenting
vnoremap > >gv|     " restore visual mode after indenting
" note: the pipe terminates the map command; the comments are empty commands


" FileType-dependent settings (the bad way?)
autocmd FileType vim setlocal expandtab shiftwidth=2
if !&spell
  " enable spell for these files if I've doing it globally already
  autocmd FileType gitcommit setlocal spell spelllang=en_us
  autocmd FileType markdown setlocal spell spelllang=en_us
endif


" Top level <Leader> space
let mapleader = "\<Space>"
map <Leader>o :Commentary<CR>
nmap <Leader>$ :%s/\s\+$//<CR>|       " trim trailing whitespace
nmap <Leader>C :tcd %:h<CR>:pwd<CR>|  " change window/tab cwd to current file's
nmap <Leader>b :b#<CR>
nmap <Leader>f :Ranger<CR>
nmap <Leader>l :nohlsearch<CR>
nmap <Leader>q :q<CR>
nmap <Leader>s :sp<CR>
nmap <Leader>t :tabe<CR>
nmap <Leader>v :vsp<CR>
nmap <Leader>w :update<CR>|           " :write only if the buffer was modified
nmap <Leader>x :exit<CR>|             " :update | quit
vmap <Leader>A :'<,'>sort<CR>|        " sort visual selection asceding
vmap <Leader>D :'<,'>sort!<CR>|       " sort visual selection descending
if has('nvim')
  nmap <Leader>` :source ~/.config/nvim/init.vim<CR>
else
  nmap <Leader>` :source ~/.vim/vimrc<CR>
endif


" <Leader> [a]spell space
nmap <Leader>ae :setlocal spell spelllang=en_us<CR>
nmap <Leader>ap :setlocal spell spelllang=pt_br<CR>
nmap <Leader>aa :setlocal spell spelllang=en_us,pt_br<CR>
nmap <Leader>al :setlocal nospell<CR>


" <Leader> [m]ake space
nmap <Leader>m0 :make clean<CR>
nmap <Leader>mc :make check<CR>
nmap <Leader>md :make doc<CR>
nmap <Leader>mm :make<CR>
nmap <Leader>mt :make test<CR>
autocmd FileType rust nmap <Leader>mC :make clippy<CR>
autocmd FileType rust nmap <Leader>mD :make doc --open<CR>
autocmd FileType rust nmap <Leader>mT :RustTest<CR>
autocmd FileType rust nmap <Leader>mf :make fmt<CR>
autocmd FileType rust nmap <Leader>mm :make build<CR>
" note: building from Cargo.toml is currently broken


" TO-DO list
" - informative status bar with airline or similar
" - git information on the status bar with fugitive or similar
" - haxe syntax (vaxe) and lsp server (hls)
" - enuch?
" - bufferline?
" - multiple-cursors?
" - use ripgrep in :grep
" - window size/placement shortcuts (2/3? center, only)
" - auto breaklines in certain formats (markdown? git?)
" - faster way to run previous commands


" Left out for now
" noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
" noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
