all: ctags fonts git ssh vim zsh bash screen _phony

ctags fonts git ssh vim zsh bash screen: _phony
	make -C $@

systemd liquidctl krakenx: /bin/systemctl _phony
	make -C $@

.PHONY: _phony

