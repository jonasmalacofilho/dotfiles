function confirm -d "Request user confirmation before executing a command"
    echo "Confirming the execution of command:"
    echo "    $argv"
    read --nchars 1 -l response --prompt-str="Are you sure you want to execute it: (y/N) "
    or return  1
    switch $response
        case y Y
            $argv
        case n N ''
            echo Aborted
            return 2
        case '*'
            echo Invalid answer
            return 1
    end
end
