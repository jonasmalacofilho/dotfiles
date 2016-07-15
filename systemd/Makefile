DEST=~/.config/systemd/user

all: $(DEST)/haxe.service $(DEST)/ssh-agent.service _phony

$(DEST)/%.service: %.service
	mkdir -p $(DEST)
	cp $? $@

.PHONY: _phony

