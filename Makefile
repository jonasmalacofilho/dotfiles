all: ctags fonts git ssh vim nvim zsh bash _phony

ctags fonts git ssh vim nvim zsh bash: _phony
	make -C $@

systemd liquidctl krakenx: /bin/systemctl _phony
	make -C $@

.PHONY: _phony
