all: vim-dotfiles compiz-dotfiles

# Vim
vim-dotfiles: ~/.vim ~/.vimrc
~/.vim: vim
	ln -si ${PWD}/vim ~/.vim
~/.vimrc:
	ln -si ~/.vim/vimrc ~/.vimrc 

# Compiz
compiz-dotfiles: ~/.config/compiz-1/compizconfig/Default.ini
~/.config/compiz-1/compizconfig/Default.ini: compiz/Default.ini
	ln -si ${PWD}/compiz/Default.ini ~/.config/compiz-1/compizconfig/Default.ini

.PHONY: all vim-dotfiles compiz-dotfiles

