INSTALL_DIR=/usr/local/bin
SYSTEMD_DIR=/etc/systemd/system

install: liquidcfg liquidcfg.service liquiddyncfg liquiddyncfg.service liquiddyncfg.timer _phony
	mkdir -p "$(INSTALL_DIR)"
	cp liquid*cfg "$(INSTALL_DIR)"
	cp liquid*cfg.service "$(SYSTEMD_DIR)"
	cp liquid*cfg.timer "$(SYSTEMD_DIR)"
	systemctl daemon-reload

.PHONY: _phony
