SYSTEMD_DIR=/etc/systemd/system

install: krakenx-config.service /usr/bin/systemctl
	cp krakenx-config.service "$(SYSTEMD_DIR)"
	systemctl daemon-reload

.PHONY: install
