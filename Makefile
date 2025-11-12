empty: _phony

liquidctl neomutt systemd tmux: _phony
	make -C $@

.PHONY: _phony
