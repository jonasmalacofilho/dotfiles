essential: bash bin kitty nvim ssh tmux _phony

bash bin kitty liquidctl neomutt nvim ssh systemd tmux: _phony
	make -C $@

.PHONY: _phony
