# A TUI pomodoro timer.
#
# Requires charmbracelet/gum and either trehn/termdown or caarlos0/timer. At least the first two are
# available from the oficial Arch repos.
#
# Adapted from: https://gist.github.com/bashbunni/e311f07e100d51a883ab0414b46755fa?permalink_comment_id=5984105#gistcomment-5984105
# Adapted from: https://gist.github.com/bashbunni/e311f07e100d51a883ab0414b46755fa

function pom
        # Parse arguments for timer choice
        set -l use_timer true
        for arg in $argv
                switch $arg
                        case --timer -t
                                set use_timer false
                end
        end

        set split $POMO_SPLIT
        if ! test -n "$split"
                set split $(gum choose "25/5" "50/10" "all done" --header "Choose a pomodoro split:")
        end

        switch $split
                case 25/5
                        set work 25m
                        set break 5m
                case 50/10
                        set work 50m
                        set break 10m
                case 'all done'
                        return
        end

        # Choose timer based on flag
        if test $use_timer = true
                set timer_cmd termdown
        else
                set timer_cmd timer --format 24h
        end

        $timer_cmd $work && notify-send -u critical "Pomodoro" "Work Timer is up! Take a break 😊"

        gum confirm "Ready for a break?" \
                && $timer_cmd $break \
                && notify-send -u critical "Pomodoro" "Break is over! Get back to work 😬" \
                || pom
end
