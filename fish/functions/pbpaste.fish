function pbpaste --description "Paste data from the clipboard"
    if command -q pbpaste
        command pbpaste
    else if command -q wl-paste
        wl-paste --no-newline
    else if command -q xsel
        xsel --clipboard --output
    else if command -q xclip
        xclip -selection clipboard -o
    else
        echo "pbpaste: no clipboard backend found (install wl-clipboard, xsel, or xclip)" >&2
        return 1
    end
end
