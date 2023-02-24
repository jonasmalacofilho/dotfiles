function arch_update -d "Update Arch system with pacman"
    # REQUIRES: neovim-symlinks or neovim-drop-in or vim[diff]
    sudo pacman -Syu
    and sudo pacdiff
end
