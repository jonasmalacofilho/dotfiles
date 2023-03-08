function in_private_repo --description "Is this a private GitHub repository?"
    set -l response (gh repo view --json isPrivate)
    or begin
        echo "Failed to fetch GitHub metadata"
        return 2
    end

    set -l result (echo -e $response | jq .isPrivate)
    or begin
        echo -n "Failed to parse response: $response"
        return 3
    end

    switch $result
        case false
            set_color red
            echo "Repoository is public!"
            set_color normal
            return 1
        case true
            echo "Repoository is private."
            return 0
        case "*"
            echo -n "Unexpected result: $result"
            return 4
    end
end
