function arch-update -d "Update Arch system with pacman"
    switch (read --prompt-str="Clean pacman and yay's caches first? (y/N) ")
        case y Y
            sudo yay -Sc
            or return 1
        case n N ''
            # noop
        case '*'
            echo Invalid answer
            return 1
    end

    sudo pacman -Syu
    or return 1

    # pacdiff requires neovim-symlinks or neovim-drop-in or vim[diff]
    sudo pacdiff --threeway --backup
end
