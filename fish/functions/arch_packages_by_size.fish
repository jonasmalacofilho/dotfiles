function arch_packages_by_size -d "List installed packages sorted by size"
    # from: https://bbs.archlinux.org/viewtopic.php?pid=1585788#p1585788

    pacman -Qi |
        grep -E '^(Name|Installed)' |
        cut -f2 -d':' |
        paste - - |
        column -t |
        sort -nrk 2 |
        grep MiB
end
