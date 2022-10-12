help:
	@echo "Usage: make <target>..."
	@echo ""
	@echo "essential: bash git nvim ssh zsh"
	@echo "other targets: kitty liquidctl neomutt systemd vim"

essential: bash git nvim ssh zsh

alacritty bash git kitty liquidctl neomutt nvim ssh systemd vim zsh: _phony
	make -C $@

.PHONY: help essential _phony
