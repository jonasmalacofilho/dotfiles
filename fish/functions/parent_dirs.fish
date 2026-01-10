# Adapted from https://github.com/IlanCosman/tide/blob/fcda500d2c29/functions/_tide_parent_dirs.fish
# Original Copyright © 2020 Ilan Cosman, licensed under the MIT License.
function parent_dirs
    string escape (
        for dir in (string split / -- $PWD)
            set -fa parts $dir
            if test -n "$parts"
                string join / -- $parts
            else
                echo /
            end
        end
    )[-1..1]
end
