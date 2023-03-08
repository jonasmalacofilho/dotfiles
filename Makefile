help:
	@echo "Usage: make <target>..."
	@echo ""
	@echo "essential: bash fish git kitty nvim ssh"
	@echo "other targets: liquidctl neomutt systemd"

essential: bash fish git kitty nvim ssh

bash fish git kitty liquidctl neomutt nvim ssh systemd: _phony
	make -C $@

.PHONY: help essential _phony
