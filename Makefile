common: bash git nvim ssh zsh

bash git krakenx liquidctl nvim ssh systemd vim zsh: _phony
	make -C $@

.PHONY: common _phony
