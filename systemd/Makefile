DEST=~/.config/systemd/user

default:

haxe: $(DEST)/haxe.service reload
check-gtx1080: $(DEST)/check-gtx1080.service reload
calvin-health-check: $(DEST)/calvin-health-check-boot.service $(DEST)/calvin-health-check.service $(DEST)/calvin-health-check.timer reload

reload:
	systemctl --user daemon-reload

$(DEST)/%.service: %.service
	mkdir -p $(DEST)
	cp $? $@

$(DEST)/%.timer: %.timer
	mkdir -p $(DEST)
	cp $? $@

.PHONY: default reload
