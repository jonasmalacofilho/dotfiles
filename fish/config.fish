if status is-interactive
    # Commands to run in interactive sessions go here.

    # Delete one word backwards with C-BS
    bind \b backward-kill-word

    # To have abbreviations expand anywhere in the command line, e.g. after
    # `sudo`, use `--position anywhere`.
    #
    # This achieves a somewhat similar result as aliasing `sudo = 'sudo '` in
    # bash or zsh, but with a higher chance of unwanted expansions. Luckly this
    # it will soon(ish) be possible to restrict this to specific commands:
    #
    # https://github.com/fish-shell/fish-shell/pull/10452

    abbr -a _ sudo
    abbr -a b btop
    abbr -a bl bombadil link
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

    abbr -a --set-cursor m 'math "%"'

    abbr -a nv nvim

    abbr -a c cargo
    abbr -a cnt cargo nextest run
    abbr -a cb cargo build
    abbr -a cbr cargo build --release
    abbr -a cr cargo r --
    abbr -a crr cargo r -r --
    abbr -a cw cargo watch -x clippy -x '"nextest run"' -x '"b"'

    # Custon one-line log format with extra integration.
    set GIT_LOG_SUMMARY "%C(auto)%h%d %s %C(dim)[%aN, %ar]%C(reset)"
    # Format preferred for commit references in the Linux kernel.
    set GIT_LOG_KERNEL "%C(auto)%h%C(reset) (\"%s\")"

    abbr -a g git
    abbr -a ga git add
    abbr -a gb git branch
    abbr -a gc git commit
    abbr -a gca git commit --all
    abbr -a gcaa git commit --all --amend
    abbr -a gcm git switch "(git_main_branch)"
    abbr -a gco git switch
    abbr -a gcp git commit -p
    abbr -a gcpa git commit -p --amend
    abbr -a gd git diff
    abbr -a gdc git diff --cached
    abbr -a gdt 'GIT_EXTERNAL_DIFF="difft --display=side-by-side"' git diff
    abbr -a gf git fetch
    abbr -a gl git pull
    abbr -a glg 'git log --format=$GIT_LOG_SUMMARY --graph'
    abbr -a glga 'git log --format=$GIT_LOG_SUMMARY --graph --all'
    abbr -a glk 'git log --format=$GIT_LOG_KERNEL'
    abbr -a glog git log --stat
    abbr -a glop git log --stat -p
    abbr -a gme git merge
    abbr -a gp git push
    abbr -a gre git rebase
    abbr -a gsh git show
    abbr -a gst git status -bs
    abbr -a gu "git add . && git commit -m update && git push"

    abbr -a --command gh b browse

    # Manual kitty integration, since from its (and the system's) perspective my default shell is
    # bash (so that /etc/profile.d/* gets sourced).
    # Docs: https://sw.kovidgoyal.net/kitty/shell-integration/#manual-shell-integration
    if set -q KITTY_INSTALLATION_DIR
        set --global KITTY_SHELL_INTEGRATION enabled
        source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
        set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
    end
end
