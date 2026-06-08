function pbcopy --description "Copy data from STDIN to the clipboard"
    if command -q pbcopy
        command pbcopy
    else if command -q wl-copy
        wl-copy
    else if command -q xsel
        xsel --clipboard --input
    else if command -q xclip
        xclip -selection clipboard
    else
        echo "pbcopy: no clipboard backend found (install wl-clipboard, xsel, or xclip)" >&2
        return 1
    end
end
