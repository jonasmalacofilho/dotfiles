all: ~/.bash_profile ~/.bashrc _phony

~/.%: %
	ln -si $(CURDIR)/$* $@

.PHONY: _phony

