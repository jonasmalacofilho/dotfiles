essential: bash nvim ssh tmux _phony

bash liquidctl neomutt nvim ssh systemd tmux: _phony
	make -C $@

.PHONY: _phony
