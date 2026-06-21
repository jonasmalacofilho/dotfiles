function confirm2 -d "Summarize \$argv with Claude, then confirm before executing it"
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
    set -l normal (set_color normal)

    echo $dim"Asking Claude what this would do..."$normal
    echo
    claude --model opus --effort high --allowed-tools "Bash(man:*)" -p $prompt </dev/null
    echo

    echo "Command: "(set_color --bold)$cmd$normal
    # Delegate to confirm for the y/N prompt and execution, forwarding flags.
    set -l fwd
    set -q _flag_accept_no; and set -a fwd --accept-no
    set -q _flag_prompt; and set -a fwd --prompt $_flag_prompt
    confirm $fwd -- $argv
end
