function gnome-nested-shell -d "Start a nested GNOME shell (Wayland only)"
    MUTTER_DEBUG_DUMMY_MODE_SPECS=1920x1080 dbus-run-session -- gnome-shell --nested --wayland
end
