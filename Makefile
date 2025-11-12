essential: bash tmux _phony

bash liquidctl neomutt systemd tmux: _phony
	make -C $@

.PHONY: _phony
