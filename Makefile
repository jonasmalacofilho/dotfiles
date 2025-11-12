essential: bash ssh tmux _phony

bash liquidctl neomutt ssh systemd tmux: _phony
	make -C $@

.PHONY: _phony
