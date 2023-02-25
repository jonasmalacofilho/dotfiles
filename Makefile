help:
	@echo "Usage: make <target>..."
	@echo ""
	@echo "essential: bash git nvim ssh zsh"
	@echo "other targets: kitty liquidctl neomutt systemd"

essential: bash git nvim ssh zsh

alacritty bash fish git kitty liquidctl neomutt nvim ssh systemd zsh: _phony
	make -C $@

.PHONY: help essential _phony
