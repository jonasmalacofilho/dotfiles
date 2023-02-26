# taken from: https://github.com/lewisacidic/fish-git-abbr/blob/abe95203b7fc/functions/git_main_branch.fish
# (which in turn might be based on: https://github.com/ohmyzsh/ohmyzsh/blob/27f31799df36/plugins/git/git.plugin.zsh#L30-L41)

function git_main_branch -d "Detect name of main branch of current git repository"
    # heuristic to return the name of the main branch
    command git rev-parse --git-dir &> /dev/null || return
    for ref in refs/{heads,remotes/{origin,upstream}}/{main,master,trunk}
        if command git show-ref -q --verify $ref
            echo (string split -r -m1 -f2 / $ref)
            return
        end
    end
    echo main
end
