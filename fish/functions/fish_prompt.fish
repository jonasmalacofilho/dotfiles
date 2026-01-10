# TODO: customize VCS prompt (see /usr/share/fish/.../sample_prompts/informative_vcs.fish)
# TODO: put the commandline on its own line (requires reimplementing the right rpompt)
# TODO: make both left and right prompts stand out (maybe add solid bars)
function fish_prompt
    set -l normal (set_color normal)
    set -l cwd_color (set_color brgreen)
    set -l vcs_color (set_color brmagenta)
    set -l alert_color (set_color red)

    set -l pwd {$cwd_color}(prompt_pwd -D 2)

    set -l vcs
    if not contains -- --final-rendering $argv
        set vcs {$vcs_color}(fish_vcs_prompt "(%s)")
    end

    set -l login
    set -l marker {$normal}\$
    if set -q SSH_TTY
        set -l user_color (set_color bryellow)
        set -l host_color (set_color brcyan)
        set login {$user_color}(whoami){$normal}@{$host_color}(prompt_hostname)
    else if fish_is_root_user
        set login {$alert_color}root
        set marker {$alert_color}#
    end

    echo
    string join -n ' ' -- $login $pwd $vcs $marker $normal
end
