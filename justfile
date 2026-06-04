link:
    bombadil link -p macos

fmt:
    dprint fmt

fmt-check:
    dprint check

check-links:
    #!/usr/bin/env bash
    green=$'\033[32m'
    yellow=$'\033[33m'
    bold=$'\033[1m'
    dim=$'\033[2m'
    reset=$'\033[0m'
    warned=0
    echo
    echo "  ${bold}Checking bombadil symlinks${reset}  ${dim}profile: macos${reset}"
    echo
    while IFS=$'\t' read -r src tgt; do
        if [ -L "$tgt" ]; then
            actual=$(readlink "$tgt")
            if [ "$actual" = "$src" ]; then
                echo "  ${green}ok${reset}    $tgt"
            else
                echo "  ${yellow}warn${reset}  $tgt"
                echo "        actual:   $actual"
                echo "        expected: $src"
                warned=1
            fi
        elif [ -e "$tgt" ]; then
            echo "  ${yellow}warn${reset}  $tgt  ${dim}(not a symlink)${reset}"
            warned=1
        else
            echo "  ${yellow}warn${reset}  $tgt  ${dim}(missing)${reset}"
            warned=1
        fi
    done < <(bombadil get dots macos | awk -F ' => ' '{split($1,a,": "); print a[2] "\t" $2}')
    echo
    exit $warned
