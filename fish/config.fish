fish_add_path /usr/local/bin
set -x VISUAL nvim
set -x EDITOR nvim

# TODO add https://github.com/fischerling/plugin-wd

if status is-interactive
    # Commands to run in interactive sessions can go here

    abbr -a _ sudo
    abbr -a f fg
    abbr -a icat kitty +kitten icat
    abbr -a jo xdg-open
    abbr -a l ls -lah
    abbr -a md mkdir -p
    abbr -a t1 tree -L 1
    abbr -a t2 tree -L 2
    abbr -a t3 tree -L 3
    abbr -a v nvim

    abbr -a --set-cursor vg "vgrep % && vgrep --interactive"

    abbr -a ga git add
    abbr -a gc git commit --verbose
    abbr -a gca git commit --all --verbose
    abbr -a gcm git checkout "(git_main_branch)"
    abbr -a gco git checkout
    abbr -a gd git diff
    abbr -a gdt GIT_EXTERNAL_DIFF=difft git diff
    abbr -a gf git fetch
    abbr -a gl git pull
    abbr -a glog git log --oneline --decorate --graph
    abbr -a glok git log --graph --decorate --pretty='%C(auto)%d %C(reset)%C(auto)%h %C(reset)("%s")%C(reset)'
    abbr -a glop git log --patch --stat
    abbr -a gp git push
    abbr -a gsh git show
    abbr -a gst git status

end
