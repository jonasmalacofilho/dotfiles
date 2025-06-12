function configure-my-fish -d "Configure fish, tide, etc."
    fish_config theme choose "ayu Dark"
    tide configure --auto \
        --style=Classic \
        --prompt_colors='True color' \
        --classic_prompt_color=Dark \
        --show_time='24-hour format' \
        --classic_prompt_separators=Vertical \
        --powerline_prompt_heads=Sharp \
        --powerline_prompt_tails=Flat \
        --powerline_prompt_style='Two lines, character' \
        --prompt_connection=Disconnected \
        --powerline_right_prompt_frame=No \
        --prompt_spacing=Sparse \
        --icons='Few icons' \
        --transient=No
end
