help:
	@echo "Usage: make <target>..."
	@echo ""
	@echo "essential: bash git nvim ssh zsh"
	@echo "other targets: alacritty kitty krakenx liquidctl neomutt systemd vim"

essential: bash git nvim ssh zsh

alacritty bash git kitty krakenx liquidctl neomutt nvim ssh systemd vim zsh: _phony
	make -C $@

.PHONY: help essential _phony
