~/.config/nvim:
	ln -si $(CURDIR) $@

update-vim-plug:
	mkdir -p autoload
	curl -fLo autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

.PHONY: update-vim-plug
