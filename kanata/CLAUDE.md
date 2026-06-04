# Kanata Keyboard Layout

## Context

Porting a keyd keyboard layout (Linux) to kanata (macOS) for a MacBook Air M5 (hostname: turing,
Apple Silicon, ISO keyboard). kanata is already installed via Homebrew. The Karabiner DriverKit
VirtualHIDDevice v6.x driver is installed and activated, but its **daemon must currently be started
manually** before kanata, and nothing is set to autostart yet (see "Operational Setup").

Relevant paths:

- source keyd config (but consider "Decisions Made"): `~/Code/etcfiles/keyd/`
- kanata config: this directory, in dotfiles repo managed with toml-bombadil

---

## Hardware & Keyboards

Two physical keyboards in play; one kanata config is meant to serve both (see "Multiple keyboards").

### MacBook Air M5 (turing) — primary

- ISO physical layout, Austrian (a few extra alphas/symbols over US ANSI).
- Bottom row, left to right: `fn` `control` `option` `command` `space` `command` `option`, then the
  arrow-key cluster. Note the extra modifier (fn) and the second command/option on the right that no
  non-Mac keyboard has.
- The `fn`/Globe key is a "true" key on macOS: it reaches the OS and is interceptable/remappable in
  kanata.

### Aula F75 — the mech in heaviest use

- 75% Windows/ANSI/US, fewer keys than the Mac.
- Bottom row, left to right: `control` `super` `alt` `space` `fn` `control`, then the arrow-key
  cluster. (The `fn` here is the keyboard's own fn, see below.)
- The Aula `fn` key is firmware-only: it never reaches the OS and can only be reassigned with Aula's
  proprietary (Windows) software, and even then only to keyboard-scope functions — it can never be
  sent to the OS as an ordinary key.
- The keyd setup assumed the Aula was firmware-remapped: fn-labelled key -> Right Alt, Esc-labelled
  key -> Fn. The Mac port needs a different scheme (see open decision below).
- The Aula has a "mac mode" but it has other issues; decision: **not using it**.

#### OPEN DECISION: where Mac's fn lands on the Aula

Mac's config leans on a real `fn` key, but the Aula can't send fn to the OS. Leaning toward using
the Esc-labelled key position to stand in for Mac's fn, which implies relocating the Aula's own fn
functionality elsewhere and adjusting the firmware remaps accordingly. Not yet settled — revisit
when the Aula is actually wired into this config.

---

## Kill Switch (Panic Exit)

kanata has a **built-in** emergency exit; we rely on it rather than building our own (a `cmd`/macro
kill switch would be strictly less reliable, since it depends on the config loading correctly and
the combo being reachable in the current layer).

- **Combo: Left Control + Space + Escape, held simultaneously**, terminates the kanata process.
- It acts on **raw input before any remapping**, so no config bug, wrong layer, or broken alias can
  disable it. It is hardcoded in kanata and cannot be configured or turned off.
- **Caveat for turing:** because we swap `fn` <-> `lctl`, press the key _physically labelled_
  Control (not fn) — the panic watches pre-remap HID, where that key is still Left Control. Esc is
  the real Esc key, Space is space.
- **Tested and confirmed working** on turing (macOS + Karabiner VHID).

Independent fallbacks (defense in depth): run kanata in a foreground terminal and kill it with the
mouse (quit / close window -> SIGHUP), or `sudo pkill kanata` from another shell. Note `Ctrl+C` in
kanata's own terminal is unreliable, since physical Control is remapped to fn in the default layer.

---

## Current Working Config

Read `./kanata.kbd`.

### What's tested and working

- `fn` ↔ `lctl` swap (fn/Globe and Control keys swapped)
- `caps` tap=Esc, hold=nav layer (using `tap-hold-press` at 200ms)
- nav layer: hjkl=arrows, yuio=home/pgdn/pgup/end
- ISO backtick fix: `grv` ↔ `lsgt` swap, so backtick/tilde sits left of 1 (not left of z) under the
  US OS layout (may become unnecessary once the symbols layer handles grave/tilde)
- oneshot modifiers (tap = oneshot, hold = normal modifier; 200ms, chaining works): left/right Shift
  only. This deviates from keyd, which also made Control and Alt oneshot; on the Mac those stay as
  plain modifiers for now.
- esc: tap = Esc, hold = control layer (overload, 200ms), same pattern as caps
- control layer (held via esc): media + volume on the Mac's F7-F12 (prev / play-pause / next, mute,
  vol- / vol+), plus Mission Control (F3) and Spotlight (F4). keyd's equivalent layer was empty, so
  this is new; the macOS-specific Mission Control/Spotlight usages (mctl/sls) work here.
- control-layer F5 = live config reload (kanata `lrld`); an invalid reload is rejected and the
  running config is kept. Workflow: edit source, `bombadil link`, then esc+F5 (no restart).
- moved fn key (the physical Control-labelled key) tap = fn, hold = fnrow layer reproducing the
  MacBook's native function row: F1/F2 brightness, F3 Mission Control, F4 Spotlight, F5 Dictation,
  F6 Do Not Disturb, F7-F12 media/volume. For the MacBook's own keyboard; other keyboards use the
  control layer instead. F5/F6 assume the modern layout (else `bldn`/`blup` for keyboard backlight).
  All the macOS-specific actions confirmed working through the VHID on turing.
- symbols layer (held or oneshot via right Option), step 1 = programming symbols. Ports keyd's
  `[symbols]` without relying on an AltGr OS layout; each key outputs directly: 1-5 give the shifted
  number symbols, and the letter block gives the brackets, parens, math/shell punctuation, backtick,
  backslash, caret and tilde. Backtick/tilde are emitted via `grv`/`S-grv` (the grave usage the OS
  maps to them here). Right Option no longer types Option (left Option still does). Accent positions
  (e/a/u/i/o and comma) type plain letters until step 2.

---

## Decisions Made

### General

- macOS-only config for now (no cross-platform with Linux yet)
- QWERTY only (no layout switching)
- no home row mods (not in use in Linux, can be added a later point)
- `tap-hold-press` is the right variant for overload-style behavior (hold triggers on next key
  press, not just timeout) — matches keyd's `overload`
- for now, kanata is run as: `sudo kanata --cfg ~/.config/kanata/kanata.kbd`

### Portuguese characters / symbols layer

- All accented characters will be output as direct unicode (`(unicode á)` etc.) rather than relying
  on macOS input method or dead keys at the OS level
- Dead keys (dead grave, dead tilde) will be implemented as kanata-internal layers
- Characters needed for Brazilian Portuguese:
  - Acute: á é í ó ú (+ uppercase)
  - Tilde: ã õ (+ uppercase), via dead-tilde layer
  - Circumflex: â ê ô (+ uppercase), via dead-circumflex layer
  - Grave: à (+ uppercase), via dead-grave layer
  - Cedilla: ç Ç (direct)

### Function keys / media keys

- Known limitation: Karabiner virtual keyboard breaks fn+Fkey media control behavior — fn key state
  is lost through the virtual HID device
- Solution: map media keys (brightness, volume) explicitly in the control layer rather than relying
  on fn+Fkey (done for volume/playback on F7-F12; brightness on F1/F2 not added yet)

### Multiple keyboards

- An ANSI US mechanical keyboard will be added later
- Plan: single kanata config, single instance; differences between keyboards are small enough
  (mainly the fn key swap, which the mech won't need)
- Revisit when the mech is actually connected

---

## Features Still To Port (from keyd)

In rough priority order:

1. **Nav layer — remaining keys** (currently only hjkl/yuio are mapped; some of these may be dropped
   or adjusted):
   - `p` = delete
   - `backspace` = C-backspace (delete word)
   - `enter` = S-enter
   - `'` = `"`
   - `e` = C-{ (kitty: new window)
   - `r` = C-} (kitty: close window)
   - `rightshift` = capslock
   - mod activators on home row: s=meta, d=alt, f=ctrl, g=shift, space=shift
   - shift+mod nav sublayers: w=S+meta, e=S+alt, r=S+ctrl (for shift+nav combos)
   - `f1` (or equivalent) = enter control layer

2. **Symbols layer — accents and dead keys** (step 2; the ASCII symbols and right-Option activation
   are done, see "tested and working"). Remaining:
   - direct-unicode acutes and cedilla in the symbols layer: e=é a=á u=ú i=í o=ó, comma=ç (+ upper)
   - dead-key entry points and their sublayers:
     - grave key → dead-grave layer (à + upper)
     - tilde key → dead-tilde layer (ã õ + upper)
     - circumflex → dead-circumflex layer (â ê ô + upper); no key assigned yet in keyd

---

## Operational Setup (not from keyd)

Two processes must be running, both currently started **manually** and neither autostarted yet:

1. **Karabiner VHID daemon** (prerequisite — must be up before kanata):
   ```
   sudo '/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon'
   ```
   (The driver itself is activated via the `Karabiner-VirtualHIDDevice-Manager.app ... activate`
   manager binary; that part is already done.)
2. **kanata**: `sudo kanata --cfg ~/.config/kanata/kanata.kbd`

- **Autostart**: still to do — set both to start automatically (e.g. launchd LaunchDaemons, since
  they need root). Hold off until the config is trusted; for now manual runs are preferred so the
  foreground terminal doubles as a fallback kill switch.

---

## Key kanata Concepts (for reference)

- `defsrc`: physical keys to intercept (order matters, layout is cosmetic)
- `deflayer`: what those keys do; must match defsrc entry count; `_` = passthrough
- `defalias`: named complex behaviors, referenced as `@name` in layers
- `(tap-hold-press T H tap-action hold-action)`: hold triggers on next key press
- `(one-shot T action)`: next key press gets the modifier applied, then releases
- `(layer-while-held name)`: layer active only while key is held
- `(layer-toggle name)`: toggle layer on/off
- `(unicode á)`: directly output a unicode character
- `process-unmapped-keys yes`: pass through all keys not in defsrc

## kanata Key Names (macOS relevant)

- `fn` = fn/Globe key (interceptable on Apple keyboards)
- `lctl rctl` = Control, `lalt ralt` = Option, `lmet rmet` = Command
- `lsft rsft` = Shift
- `caps` = Caps Lock
- `bspc` = Backspace, `ret` = Enter
- `spc` = Space
- Media: `volu vold mute pp prev next brup brdown`
- macOS-specific: `mctl` (Mission Control), `sls` (Spotlight), `lpad` (Launchpad)
