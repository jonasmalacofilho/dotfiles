essential: bash bin git kitty nvim ssh tmux _phony

bash bin git kitty liquidctl neomutt nvim ssh systemd tmux: _phony
	make -C $@

.PHONY: _phony
