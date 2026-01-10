function fish_right_prompt
    set -l last_status $status
    set -l normal (set_color normal)
    set -l status_color (set_color brblack)
    set -l alert_color (set_color red)
    set -l parts

    if not contains -- --final-rendering $argv
        if path is (parent_dirs)/Cargo.toml
            set -l v
            set -l rust_icon " "
            rustc --version | string match -qr "(?<v>[\d.]+)"
            set -a parts "Rust $rust_icon $v"
        end
    end

    if test $last_status -ne 0
        set -l signal (fish_status_to_signal $last_status)
        if test $signal != $last_status
            set -a parts {$alert_color}$signal{$status_color}
        end
        set -a parts {$alert_color}$last_status{$status_color}
    else
        set -a parts $last_status
    end

    set -l last_duration (
        math -s0 "$CMD_DURATION/3600000" # Hours
        math -s0 "$CMD_DURATION/60000"%60 # Minutes
        math -s1 "$CMD_DURATION/1000"%60
        math $CMD_DURATION
    )
    if test $last_duration[1] != 0
        set -a parts "$last_duration[1] h $last_duration[2] m $last_duration[3] s"
    else if test $last_duration[2] != 0
        set -a parts "$last_duration[2] m $last_duration[3] s"
    else if test $last_duration[3] -ge 1
        set -a parts "$last_duration[3] s"
    else
        set -a parts "$last_duration[4] ms"
    end

    set -a parts (date +%T)

    # printf "DEBUG:\n%s\n" $parts >/dev/stderr
    echo -ns $status_color "// "
    string join "" -- \
        (string join -n " | " --  $parts) \
        $normal
end
