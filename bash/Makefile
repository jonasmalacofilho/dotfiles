all: ~/.bash_profile ~/.bashrc

~/.%: %
	ln -si $(CURDIR)/$* $@

.PHONY: all
