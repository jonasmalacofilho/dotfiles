function arch-update -d "Update Arch system with pacman"
    confirm --accept-no --prompt "Clean pacman cache first?" -- sudo pacman -Sc
    or return

    echo -e "\nUpgrading pacman packages"
    sudo pacman -Syu
    or return

    # pacdiff requires neovim-symlinks or neovim-drop-in or vim[diff]
    echo -e "\nChecking for pacnew files"
    sudo pacdiff --threeway --backup
end
