function yay-update -d "Update AUR/yay packages with yay"
    confirm --accept-no --prompt "Clean yay cache first?" -- sudo yay -Sca
    or return

    echo -e "\nUpgrading AUR/yay packages"
    yay -Sua
    or return

    # pacdiff requires neovim-symlinks or neovim-drop-in or vim[diff]
    echo -e "\nChecking for pacnew files"
    sudo pacdiff --threeway --backup
end
