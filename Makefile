all: ~/.vim ~/.vimrc

~/.vim: vim
	ln -si ${PWD}/vim ~/.vim

~/.vimrc:
	ln -si ~/.vim/vimrc ~/.vimrc 

