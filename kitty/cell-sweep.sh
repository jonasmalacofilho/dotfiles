#!/usr/bin/env bash
# kitty font_size -> cell-size sweep.
#
# **Important**: must be executed from within a kitty window with remote control enabled:
#
#   kitty -o allow_remote_control=yes
#
# Application:
#
# - run `./cell-sweep.sh 40 80 1`
# - given:
#   - `s0` = largest size with `w/h` matching the design value (usually 0.500)
#   - `w0` = corresponding width for `s0`
# - approximate `s/w` by `s0/w0`
# - set half-step as `s/w`, full step as `2*s/w`
# - set initial font size to any value from `seq s0 -s/w 0`
#
# To double check:
#
# - do a sweep and save the results to a file:
#   ./cell-sweep.sh 9 16 0.05 | tee out
# - manually look for the design w/h ratio:
#   ./cell-sweep.sh 40 80 1
#
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
