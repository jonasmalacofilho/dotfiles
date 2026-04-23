function mano --description 'Open man page jumping to where an option is defined'
    if test (count $argv) -ne 2
        echo "Usage: mano <page> <option>" >&2
        return 1
    end
    man -P "less '+/^ *$argv[2][^a-zA-Z0-9-]?'" $argv[1]
end
