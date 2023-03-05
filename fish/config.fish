if status is-interactive
    # Commands to run in interactive sessions go here.

    # To have abbreviations expand anywhere in the command line, e.g. after
    # `sudo`, use `--position anywhere`. This achieves a similar result as
    # aliasing `sudo = 'sudo '` in bash and zsh.

    abbr -a _ sudo
    abbr -a b btop
    abbr -a f fg
    abbr -a h htop
    abbr -a icat kitty +kitten icat
    abbr -a jo xdg-open
    abbr -a l ls -lah
    abbr -a md mkdir -p
    abbr -a n nvim # because abbrs visibly expand, I now keep trying to start [n]vim with n
    abbr -a py python
    abbr -a t1 tree -L 1
    abbr -a t2 tree -L 2
    abbr -a t3 tree -L 3
    abbr -a v nvim

    abbr -a ga git add
    abbr -a gb git branch
    abbr -a gc git commit --verbose
    abbr -a gca git commit --verbose --all
    abbr -a gcm git checkout "(git_main_branch)"
    abbr -a gco git checkout
    abbr -a gd git diff
    abbr -a gdt 'GIT_EXTERNAL_DIFF="difft --display=side-by-side"' git diff
    abbr -a gf git fetch
    abbr -a gl git pull
    abbr -a glog git log --decorate --graph --oneline
    abbr -a glok git log --graph --decorate --pretty='%C(auto)%d %C(reset)%C(auto)%h %C(reset)("%s")%C(reset)'
    abbr -a glop git log --patch --stat
    abbr -a gp git push
    abbr -a gsh git show
    abbr -a gst git status

    # Manual kitty integration, since from its (and the system's) perspective my default shell is bash,
    # so that /etc/profile.d/* gets sourced.
    if set -q KITTY_INSTALLATION_DIR
        set --global KITTY_SHELL_INTEGRATION enabled
        source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
        set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
    end
end
