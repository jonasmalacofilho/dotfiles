all: compiz tmux vim shz _phony

compiz tmux vim zsh: _phony
	make -C $@

.PHONY: _phony

