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
  set autoread        " don't work on outdated files
  set encoding=utf-8  " ensure sane encoding
  set nocompatible    " don't break vim for vi
  set noexrc          " don't source rc files in current directory
  " to make this configuration properly usable on vim:
  " - check `:h vim-differences` in nvim
  " - check vim-sensible by Tim Pope
else
  " hack around currently broken autoread in nvim
  " https://stackoverflow.com/questions/62100785
  " https://www.reddit.com/r/neovim/comments/f0qx2y
  set autoread
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * 
      \ if mode() != 'c' | checktime | endif
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
  Plug 'tpope/vim-eunuch'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  let g:markdown_syntax_minlines = 100
  Plug 'tpope/vim-markdown'

  if executable('rg')
    " use ripgrep to skip vcs and ignored files, if available
    let g:ctrlp_user_command = 'rg --files %s'
  endif
  let g:ctrlp_working_path_mode = 'a'  " start from cwd or this files' directory
  Plug 'ctrlpvim/ctrlp.vim'

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


" Language server protocol client: coc.nvim
" CocInstall coc-rust-analyzer
set updatetime=300  " minimize delays
set shortmess+=c    " don't pass messages to |ins-completion-menu|
nmap <Leader>rn <Plug>(coc-rename)
nmap [g <Plug>(coc-diagnostic-prev)
nmap ]g <Plug>(coc-diagnostic-next)
nmap gd <Plug>(coc-definition)
nmap gi <Plug>(coc-implementation)
nmap gr <Plug>(coc-references)
nmap gy <Plug>(coc-type-definition)
nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
nnoremap K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
autocmd FileType rust nnoremap <M-K> :CocCommand rust-analyzer.openDocs<CR>


" Auto completion
inoremap <expr> <C-Space> coc#refresh()
inoremap <expr> <CR>    pumvisible() ? "\<C-Y>" : "\<C-g>u\<CR>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-P>" : "\<S-Tab>"
inoremap <expr> <Tab>   pumvisible() ? "\<C-N>" : "\<Tab>"


" Utilities that overload or extend existing Vim features
nnoremap Y y$|      " yank from cursor to EOL, like C and D
nnoremap gV `[v`]|  " select text that was just pasted
vnoremap < <gv|     " restore visual mode after indenting
vnoremap > >gv|     " restore visual mode after indenting
" note: the pipe terminates the map command; the comments are empty commands
if $TERM == 'alacritty'
  " Alacritty doesn't currently support Ctrl+Shift+u for Unicode input (see:
  " alacritty/alacritty#866); since I have significant muscular memory from
  " using this feature on libvte based terminals, map CTRL-U to Vim's native
  " i_CTRL-V_digit feature in alacritty sessions and insert or command modes
  map! <C-U> <C-V>u
endif
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')|  " default to display/gj
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')|  " default to display/gk


" FileType-dependent settings (the bad way?)
autocmd FileType vim setlocal expandtab shiftwidth=2
autocmd FileType yaml setlocal expandtab shiftwidth=2
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
nmap <Leader>h :let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>' <bar> :set hlsearch<CR>
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
autocmd FileType rust nmap <Leader>i :CocCommand rust-analyzer.toggleInlayHints<CR>


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
autocmd FileType rust nmap <Leader>mF :RustFmt<CR>
autocmd FileType rust nmap <Leader>mm :make build<CR>
" note: building from Cargo.toml is currently broken


" TO-DO list
" - informative status bar with airline or similar
" - git information on the status bar with fugitive or similar
" - haxe syntax (vaxe) and lsp server (hls)
" - bufferline?
" - multiple-cursors?
" - use ripgrep in :grep
" - window size/placement shortcuts (2/3? center, only)
" - auto breaklines in certain formats (markdown? git?)
" - faster way to run previous commands
