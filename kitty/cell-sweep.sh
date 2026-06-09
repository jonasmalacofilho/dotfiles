#!/usr/bin/env bash
# kitty font_size -> cell-size sweep.
#
# Run INSIDE a kitty window with remote control on (kitty -o allow_remote_control=yes):
#
#   # Do the sweep and save the results to a file.
#   ./cell-sweep.sh 9 16 0.05 | tee out
#
#   # Look for the design w/h ration.
#   ./cell-sweep.sh 40 80 4
#
# Then pick initial font_size and change_font_size values so w/h stays close to the design ratio.
set -u

probe_cell() {                          # echoes "WIDTH HEIGHT" in device px
  local old reply code h w
  old=$(stty -g)
  stty raw -echo min 0 time 5
  printf '\033[16t' > /dev/tty           # ask for single-cell pixel size
  IFS= read -r -d t reply < /dev/tty     # reply: ESC[6;<h>;<w>t
  stty "$old"
  reply=${reply##*$'\033'}               # strip up to ESC -> "[6;h;w"
  reply=${reply#\[}                      # strip "["       -> "6;h;w"
  IFS=';' read -r code h w <<< "$reply"
  printf '%s %s' "$w" "$h"
}

start=${1:-8}; end=${2:-22}; step=${3:-0.5}

printf '%-6s %-6s %-6s %-6s\n' size width height w/h
for sz in $(seq "$start" "$step" "$end"); do
  kitten @ set-font-size "$sz" >/dev/null 2>&1 \
    || { echo "remote control not enabled"; break; }
  sleep 0.1
  read -r w h < <(probe_cell)
  ratio=$(awk "BEGIN{printf \"%.3f\", $w/$h}")
  printf '%-6s %-6s %-6s %-6s\n' "$sz" "$w" "$h" "$ratio"
done
kitten @ set-font-size 0 >/dev/null 2>&1   # restore configured default
