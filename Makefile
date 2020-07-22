help:
	@echo "Usage: make <target>..."
	@echo ""
	@echo "essential: bash git nvim ssh zsh"
	@echo "other targets: krakenx liquidctl systemd vim"

essential: bash git nvim ssh zsh

bash git krakenx liquidctl nvim ssh systemd vim zsh: _phony
	make -C $@

.PHONY: help essential _phony
