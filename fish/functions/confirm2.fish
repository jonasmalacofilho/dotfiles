function confirm2 -d "Summarize \$argv with Claude, discuss it, then confirm before executing"
    argparse --ignore-unknown "accept-no" "prompt=" -- $argv
    or return

    set -l cmd (string join ' ' -- $argv)

    set -l prompt "$(string join \n -- \
        "Concisely summarize, in 1-3 sentences, what this shell command would do if" \
        "executed. Call out any destructive or irreversible effects. Consult man pages" \
        "when it helps you be accurate, but do nothing else: run no command other than" \
        "man. If, given your limited access to external context, you are not sure what" \
        "the command would do, say so. Command:" \
        "" \
        "$cmd")"

    set -l dim (set_color brblack)
    set -l bold (set_color --bold)
    set -l normal (set_color normal)

    # Pin a session id so the summary can be resumed for an interactive discussion.
    set -l sid (uuidgen)

    echo $dim"Asking Claude what this would do..."$normal
    echo
    claude --model opus --effort high --allowed-tools "Bash(man:*)" \
        --session-id $sid -p $prompt </dev/null
    echo

    set -l header "$_flag_prompt"
    test -z "$header"; and set header "Run this command?"

    while true
        echo "Command: "$bold$cmd$normal
        switch (gum choose run discuss abort --header "$header")
            case run
                $argv
                return
            case discuss
                # Resume the summary session interactively to talk it over,
                # then return to the menu to decide.
                claude --model opus --effort high --resume $sid
            case abort '*'
                test -n "$_flag_accept_no"; and return
                echo "Aborted"
                return 2
        end
    end
end
