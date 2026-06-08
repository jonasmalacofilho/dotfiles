# Fish is always started as a non-login shell: bash or zsh is the login shell in this setup and
# handles login initialization (path_helper, /etc/profile.d/*, brew shellenv, etc.). Starting fish
# as a login shell would re-run path_helper on macOS and reorder PATH incorrectly.
if status is-login
    echo "warning: fish started as a login shell; PATH may be incorrect (see config.fish)" >&2
end

if status is-interactive
    # Commands to run in interactive sessions go here.

    fish_config theme choose "Catppuccin Mocha"

    # Kanata nav layer's word operations need no bindings here.
    #
    # nav[d]+h/l (word motion) and nav[backspace] (delete word back) both use each platform's native
    # modifier -- Option on macOS, Ctrl on Linux -- and fish already binds that modifier to the
    # word-wise action per OS: on macOS alt-left/right and alt-backspace, on Linux ctrl-left/right
    # and ctrl-backspace.
    #
    # Binding them ourselves would only affect the other, non-native modifier (e.g. real/physical
    # Ctrl+Backspace on macOS), pulling it away from its native token-wise feel -- and for motion it
    # would also possibly drop fish's prevd/nextd directory history on an empty line. Neither helps
    # the keys the nav layer actually emits.

    # Find the default command runner in the current directory.
    function find_cmd_runner
        if test -e "x"
            echo "./x"
        else if test -e "cast"
            echo "./cast";
        else if test -e "justfile"
            echo "just"
        else if test -e "Makefile"
            echo "make"
        else
            return 1
        end
    end

    # To have abbreviations expand anywhere in the command line, e.g. after
    # `sudo`, use `--position anywhere`.
    #
    # This achieves a somewhat similar result as aliasing `sudo = 'sudo '` in
    # bash or zsh, but with a higher chance of unwanted expansions. Luckly this
    # it will soon(ish) be possible to restrict this to specific commands:
    #
    # https://github.com/fish-shell/fish-shell/pull/10452

    abbr -a --set-cursor m 'math "%"'
    abbr -a _ sudo
    abbr -a _! sudo -s
    abbr -a b btop
    abbr -a bl bombadil link
    abbr -a con confirm
    abbr -a f fg
    abbr -a h htop
    abbr -a icat kitten icat
    if test (uname) = Darwin
        abbr -a jo open
    else
        abbr -a jo xdg-open
    end
    abbr -a kish kitten ssh
    abbr -a l ls -lah
    abbr -a md mkdir -p
    abbr -a n nvim
    abbr -a py python
    abbr -a t1 tree -L 1
    abbr -a t2 tree -L 2
    abbr -a t3 tree -L 3
    abbr -a w watch -d -n 1
    abbr -a we watchexec --clear
    abbr -a x -f find_cmd_runner

    abbr -a c cargo
    abbr -a cb cargo build
    abbr -a cbr cargo build --release
    abbr -a cnt cargo nextest run
    abbr -a cr cargo r --
    abbr -a crr cargo r -r --
    abbr -a cw cargo watch -x clippy -x '"nextest run"' -x '"b"'

    abbr -a g git
    abbr -a ga git add
    abbr -a gb git branch
    abbr -a gco git switch
    abbr -a gcom git main
    abbr -a gf git fetch
    abbr -a gl git pull
    abbr -a glr git pull --rebase
    abbr -a gme git merge
    abbr -a gp git push
    abbr -a gpf git fpush
    abbr -a gre git rebase
    abbr -a gsh git show
    abbr -a gst git status
    abbr -a gwt git worktree

    abbr -a gc git commit
    abbr -a gcf git commit --fixup
    abbr -a gcm git commit --amend

    abbr -a gca git commit --all
    abbr -a gcaf git commit --all --fixup
    abbr -a gcam git commit --all --amend

    abbr -a gcp git commit -p
    abbr -a gcpf git commit -p --fixup
    abbr -a gcpm git commit -p --amend

    abbr -a gd git diff
    abbr -a gdc git diff --cached
    abbr -a gdt git difft

    abbr -a glg git slog
    abbr -a glga git sloga
    abbr -a glk git klog
    abbr -a glog git log --stat
    abbr -a glop git log --stat -p

    abbr -a opus claude --model opus
    abbr -a sonnet claude --model sonnet

    # Manual kitty integration, since from its (and the system's) perspective my default shell is
    # bash (so that /etc/profile.d/* gets sourced).
    # Docs: https://sw.kovidgoyal.net/kitty/shell-integration/#manual-shell-integration
    if set -q KITTY_INSTALLATION_DIR
        set -g KITTY_SHELL_INTEGRATION enabled
        source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
        set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
    end

    if type -q starship
        starship init fish | source
    end
end
