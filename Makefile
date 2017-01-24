all: compiz ctags git ssh tmux vim zsh bash _phony

compiz ctags git ssh tmux vim zsh bash: _phony
	make -C $@

systemd: /bin/systemctl _phony
	make -C $@

.PHONY: _phony

