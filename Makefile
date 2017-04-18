all: compiz ctags fonts git ssh tmux vim zsh bash _phony

compiz ctags fonts git ssh tmux vim zsh bash: _phony
	make -C $@

systemd: /bin/systemctl _phony
	make -C $@

.PHONY: _phony

