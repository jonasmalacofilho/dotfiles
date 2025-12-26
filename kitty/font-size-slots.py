#!/usr/bin/env python3

import math

PPI = 72  # 1 pt = 1/72 in
OS_DPI = 96  # GNOME sets Xft.dpi to this regardless of true monitor DPI
CALVIN_PT = 161.5  # calvin's 4K display
HALF_PX_IN_QUOTES_PT = 0.5 * PPI / OS_DPI  # kitty cells align to the *half* pixel grid
STEPS_PER_PT = math.ceil(3 / HALF_PX_IN_QUOTES_PT)

print(f"quotes_pt render_px calvin_pt")
print(f"-----------------------------")
for quotes_pt in (x / STEPS_PER_PT for x in range(7 * STEPS_PER_PT, 13 * STEPS_PER_PT)):
    render_px = quotes_pt * OS_DPI / PPI
    half_px_aligned = "*" if round(render_px, 1) % 0.5 == 0 else " "
    calvin_pt = quotes_pt * OS_DPI / CALVIN_PT
    print(f"{quotes_pt:8.3f}{half_px_aligned} {render_px:8.1f} {calvin_pt:9.3f}")
