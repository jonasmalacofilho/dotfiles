function fish_right_prompt
    # TODO: display rust/node/venv/etc. information when applicable

    set -l last_status $status
    set -l prompt_color $fish_color_comment

    set -l last_duration (
        math -s0 "$CMD_DURATION/3600000" # Hours
        math -s0 "$CMD_DURATION/60000"%60 # Minutes
        math -s1 "$CMD_DURATION/1000"%60
        math $CMD_DURATION
    )
    if test $last_duration[1] != 0
        set last_duration "$last_duration[1] h $last_duration[2] m $last_duration[3] s"
    else if test $last_duration[2] != 0
        set last_duration "$last_duration[2] m $last_duration[3] s"
    else if test $last_duration[3] -ge 1
        set last_duration "$last_duration[3] s"
    else
        set last_duration "$last_duration[4] ms"
    end

    set -l time (date +%T)

    if test $last_status -ne 0
        set -l signal (fish_status_to_signal $last_status)
        if test $signal != $last_status
            set last_status $signal $last_status
        end
        set last_status (set_color $fish_color_status)$last_status(set_color $prompt_color)
    end

    string join "" -- \
        (set_color $prompt_color) "// " \
        (string join -n " | " --  $last_status $last_duration $time) \
        (set_color normal)
end
