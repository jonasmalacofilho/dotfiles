~/.config/neomutt: ~/.cache/neomutt
	ln -si $(CURDIR) $@

# otherwise neomutt may set it up as a regular file
~/.cache/neomutt:
	mkdir -p $@
