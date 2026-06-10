#!/usr/bin/env bash

# kitty font_size -> cell-size sweep.
#
# **Important**: must be executed from within a kitty window with remote control enabled:
#
#   kitty -o allow_remote_control=yes
#
# First:
#
# - run `./cell-sweep.sh 80 110 1`
# - determinate the design `w / h` ratio of the font
# - given:
#   - `s0` = largest size with `w / h` matching the design value (usually 0.500)
#   - `w0` = corresponding width for `s0`
# - approximate `s / w` by `s0 / w0`
# - compute `si = s / w * 3.75` [^1]
#
# Then:
# - run `./cell-sweep.sh <si> 20 <s / w>`
# - check that the (most of the) results match or are close to the design `w / h`
# - pick any such size as `font_size`
# - set `change_font_size` increment/decrement to `s / w`
#
# [^1] The rationale for `3.75` is that we want to start the next step with a size that results in a
# cell height -- roughly twice the width, even if it somewhat varies per font -- that will
# approximate to 8 px (i.e. height > 7 px, width > 3.5 px). To account for imprecision in the
# subsequent steps, pick the midpoint between that and exactly 8 px (i.e. height > 7.5 px, width >
# 3.75 px.

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
