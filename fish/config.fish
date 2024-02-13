if status is-interactive
    # Commands to run in interactive sessions go here.

    # To have abbreviations expand anywhere in the command line, e.g. after
    # `sudo`, use `--position anywhere`. This achieves a similar result as
    # aliasing `sudo = 'sudo '` in bash and zsh.

    abbr -a _ sudo
    abbr -a b btop
    abbr -a f fg
    abbr -a h htop
    abbr -a icat kitten icat
    abbr -a jo xdg-open
    abbr -a kish kitten ssh
    abbr -a l ls -lah
    abbr -a md mkdir -p
    abbr -a py python
    abbr -a t1 tree -L 1
    abbr -a t2 tree -L 2
    abbr -a t3 tree -L 3
    abbr -a w watch -d -n 1
    abbr -a we watchexec --clear

    abbr -a --position=anywhere bin trash

    abbr -a --set-cursor m 'math "%"'

    abbr -a nv nvim
    abbr -a --set-cursor nvg nvim -c "':lua live_grep(\"%\")'"
    abbr -a --set-cursor nvf nvim -c "':lua find_files(\"%\")'"

    abbr -a c cargo
    abbr -a cnt cargo nextest run
    abbr -a cb cargo build
    abbr -a cbr cargo build --release
    abbr -a cr cargo r --
    abbr -a crr cargo r -r --
    abbr -a cw cargo watch -x clippy -x '"nextest run"' -x '"b"'

    set GIT_LOG_FMT_KERNEL "%C(auto)%h%C(reset) (\"%s\")"
    set GIT_LOG_FMT_JONAS "%C(auto)%h%d %s %C(dim)[%aN, %ar]%C(reset)"

    abbr -a g git
    abbr -a ga git add
    abbr -a gb git branch
    abbr -a gc git commit -v
    abbr -a gca git commit -v --all
    abbr -a gcm git checkout "(git_main_branch)"
    abbr -a gco git checkout
    abbr -a gcp git commit -v --patch
    abbr -a gd git diff
    abbr -a gdt 'GIT_EXTERNAL_DIFF="difft --display=side-by-side"' git diff
    abbr -a gf git fetch
    abbr -a ghb gh browse
    abbr -a gl git pull
    abbr -a glg 'git log --pretty=$GIT_LOG_FMT_JONAS --graph'
    abbr -a glk 'git log --pretty=$GIT_LOG_FMT_KERNEL'
    abbr -a glog git log --stat
    abbr -a glop git log --patch --stat
    abbr -a gp git push
    abbr -a gsh git show
    abbr -a gst git status
    abbr -a gu "git add . && git commit -m update && git push"

    # Manual kitty integration, since from its (and the system's) perspective my default shell is bash,
    # so that /etc/profile.d/* gets sourced.
    if set -q KITTY_INSTALLATION_DIR
        set --global KITTY_SHELL_INTEGRATION enabled
        source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
        set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
    end
end
