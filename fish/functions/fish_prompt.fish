function fish_prompt
    # TODO: make both left and right prompts stand out

    set -l pwd (set_color $fish_color_cwd)(prompt_pwd -D 2)(set_color normal)
    set -l vcs (fish_vcs_prompt "(%s)")

    set -l login
    if set -q SSH_TTY
        set login (prompt_login)
    else if test "$EUID" = 0
        set login (set_color --dim red)root(set_color $prompt_color)
    end

    echo
    string join -n ' ' -- $login $pwd $vcs "> "
end
