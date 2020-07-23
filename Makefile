help:
	@echo "Usage: make <target>..."
	@echo ""
	@echo "essential: bash git nvim ssh zsh"
	@echo "other targets: alacritty krakenx liquidctl systemd vim"

essential: bash git nvim ssh zsh

alacritty bash git krakenx liquidctl nvim ssh systemd vim zsh: _phony
	make -C $@

.PHONY: help essential _phony
