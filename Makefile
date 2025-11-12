essential: bash bin nvim ssh tmux _phony

bash bin liquidctl neomutt nvim ssh systemd tmux: _phony
	make -C $@

.PHONY: _phony
