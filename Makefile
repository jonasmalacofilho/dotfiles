all: vim-dotfiles

# Vim
vim-dotfiles: ~/.vim ~/.vimrc
~/.vim: vim
	ln -si ${PWD}/vim ~/.vim
~/.vimrc:
	ln -si ~/.vim/vimrc ~/.vimrc 

.PHONY: all vim-dotfiles

