all: compiz ssh tmux vim zsh _phony

compiz ssh tmux vim zsh: _phony
	make -C $@

.PHONY: _phony

