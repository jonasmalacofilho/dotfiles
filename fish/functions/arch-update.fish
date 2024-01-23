function arch-update -d "Update Arch system with pacman"
    # pacdiff requires neovim-symlinks or neovim-drop-in or vim[diff]
    sudo pacman -Syu
    and sudo pacdiff --threeway --backup
end
