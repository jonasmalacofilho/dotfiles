function arch-update -d "Update Arch system with pacman"
    sudo pacman -Syu
    and sudo pacdiff # REQUIRES: neovim-symlinks, neovim-drop-in or vim[diff]
end
