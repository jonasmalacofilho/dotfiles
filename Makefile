all: compiz git ssh tmux vim zsh _phony
systemd-services: haxe _phony

compiz git ssh tmux vim zsh: _phony
	make -C $@

haxe: /bin/systemctl _phony
	make -C $@

.PHONY: _phony

