all: compiz git ssh tmux vim zsh _phony

compiz git ssh tmux vim zsh: _phony
	make -C $@

.PHONY: _phony

