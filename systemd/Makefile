DEST=~/.config/systemd/user

all: $(DEST)/haxe.service reload

reload:
	systemctl --user daemon-reload

$(DEST)/%.service: %.service /usr/bin/systemctl
	mkdir -p $(DEST)
	cp $? $@

.PHONY: all reload
