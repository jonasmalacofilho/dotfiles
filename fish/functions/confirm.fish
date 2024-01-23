function confirm -d "Request user confirmation before executing \$argv"
    argparse --ignore-unknown "accept-no" "prompt=" -- $argv
    or return

    if test -z "$_flag_prompt"
        set _flag_prompt "Are you sure you want to continue?"
    end

    read --prompt-str="$_flag_prompt (y/N) " -l response
    or return 1 # if the read was aborted with ctrl-c/ctrl-d

    switch $response
        case y Y
            $argv
        case n N ''
            if test -z "$_flag_accept_no"
                echo "Aborted"
                return 2
            end
        case '*'
            echo "Invalid answer"
            return 1
    end
end
