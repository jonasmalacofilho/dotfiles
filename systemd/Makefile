DEST=~/.config/systemd/user

all: $(DEST)/haxe.service $(DEST)/ssh-agent.service reload _phony

reload: _phony
	systemctl --user daemon-reload

$(DEST)/%.service: %.service
	mkdir -p $(DEST)
	cp $? $@

.PHONY: _phony

