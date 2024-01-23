# TODO: support --prompt-str [and, correspondingly, --]
function confirm -d "Request user confirmation before continuing"
    switch (read --prompt-str="Are you sure you want to continue? (y/N) ")
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
