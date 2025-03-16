essential: bash bin fish git kitty nvim ssh tmux _phony

bash bin fish git kitty liquidctl neomutt nvim ssh systemd tmux: _phony
	make -C $@

.PHONY: _phony
