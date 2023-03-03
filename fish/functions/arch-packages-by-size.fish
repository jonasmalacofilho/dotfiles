# Adapted from: https://bbs.archlinux.org/viewtopic.php?pid=1585788#p1585788
function arch-packages-by-size -d "List installed packages sorted by size"
    pacman -Qi |
        grep -E '^(Name|Installed)' |
        cut -f2 -d: |
        paste - - |
        column -t |
        sort -nrk 2 |
        grep MiB
end
