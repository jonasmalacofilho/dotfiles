SYSTEMD_DIR=/etc/systemd/system

install: krakenx-config.service _phony
	cp krakenx-config.service "$(SYSTEMD_DIR)"
	systemctl daemon-reload

.PHONY: _phony

