function arch_update_mirrors -a country -a limit_to -a timeout -d "Update Arch mirrorlist with best local mirrors"
    if test -z $country; set country BR; end
    if test -z $limit_to; set limit_to 4; end
    if test -z $timeout; set timeout 2; end

    set -l ignoremirrors /etc/pacman.d/ignoremirrors

    if test -f "$ignoremirrors"
        and echo :: Ignoring the following mirror patterns:
        and cat "$ignoremirrors"
    else
        and echo :: No ignoremirrors file found
        and set ignoremirrors /dev/null
    end

    and echo :: Getting ranked and up-to-date pacman mirrorlist for $country...
    and curl -s "https://archlinux.org/mirrorlist/?country=$country&protocol=http&protocol=https&ip_version=4&ip_version=6&use_mirror_status=on" |
        grep -v -f "$ignoremirrors" |
        sed -e 's/^#Server/Server/' -e '/^#/d' |
        rankmirrors -n "$limit_to" -m "$timeout" -r extra -v - |
        sudo tee /etc/pacman.d/mirrorlist
end
