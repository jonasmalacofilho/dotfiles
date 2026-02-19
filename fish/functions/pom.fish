# A TUI pomodoro timer.
#
# Requires charmbracelet/gum and trehn/termdown. Both are available from the oficial Arch repos.
#
# Adapted from: https://gist.github.com/bashbunni/e311f07e100d51a883ab0414b46755fa?permalink_comment_id=5984105#gistcomment-5984105
# Adapted from: https://gist.github.com/bashbunni/e311f07e100d51a883ab0414b46755fa

function pom
    while true
        switch $(gum choose "25/5" "50/10" "all done" --header "Choose a pomodoro split:")
        case 25/5
            set work 25m
            set break 5m
        case 50/10
            set work 50m
            set break 10m
        case "*"
            return
        end

        termdown $work && kitten notify -u critical "Pomodoro" "Work timer is up! Take a break 😊"

        gum confirm "Ready for a break?" \
            && termdown $break \
            && kitten notify -u critical "Pomodoro" "Break is over! Get back to work 😬"
    end
end
