DEST=~/.config/systemd/user

default:

haxe: $(DEST)/haxe.service reload
check-gtx1080: $(DEST)/check-gtx1080.service reload

reload:
	systemctl --user daemon-reload

$(DEST)/%.service: %.service
	mkdir -p $(DEST)
	cp $? $@

.PHONY: default reload
