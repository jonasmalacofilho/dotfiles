all: compiz haxe git ssh tmux vim zsh _phony

compiz haxe git ssh tmux vim zsh: _phony
	make -C $@

.PHONY: _phony

