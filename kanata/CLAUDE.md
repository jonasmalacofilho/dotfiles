# Kanata Keyboard Layout

## Context

Porting a keyd keyboard layout (Linux) to kanata (macOS) for a MacBook Air M5 (hostname: turing,
Apple Silicon, ISO keyboard). kanata is already installed and working via Homebrew, but not set up
to autostart. The Karabiner DriverKit VirtualHIDDevice v6.x driver is installed and active.

Relevant paths:

- source keyd config (but consider "Decisions Made"): `~/Code/etcfiles/keyd/`
- kanata config: this directory, in dotfiles repo managed with toml-bombadil

---

## Current Working Config

Read `./kanata.kbd`.

### What's tested and working

- `fn` ↔ `lctl` swap (fn/Globe and Control keys swapped)
- `caps` tap=Esc, hold=nav layer (using `tap-hold-press` at 200ms)
- nav layer: hjkl=arrows, yuio=home/pgdn/pgup/end

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
- Solution: map media keys (brightness, volume) explicitly in the config layer rather than relying
  on fn+Fkey

### Multiple keyboards

- An ANSI US mechanical keyboard will be added later
- Plan: single kanata config, single instance; differences between keyboards are small enough
  (mainly the fn key swap, which the mech won't need)
- Revisit when the mech is actually connected

---

## Features Still To Port (from keyd)

In rough priority order:

1. **Oneshot modifiers**: shift, ctrl, alt as oneshot on their respective keys
   - keyd: `shift = oneshot(shift)`, etc.
   - kanata: `(one-shot 200 lsft)` etc.

2. **esc key**: tap=Esc, hold=config layer (same overload pattern as caps)

3. **Nav layer — remaining keys** (currently only hjkl/yuio are mapped; some of these may be dropped
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
   - `f1` (or equivalent) = enter config layer

4. **Symbols layer** (activated by rightalt as oneshot):
   - Numbers row: 1=! 2=@ 3=# 4=$ 5=%
   - qwert: q=| w== e=é r=& t=*
   - asdf: a=á s=_ d=( f=) g=-
   - zxcv: z=[ x=] c={ v=} b=+
   - uiop: u=ú i=í o=ó
   - jkl: j=` k=\ l=0
   - nm,: n=^ m=~ ,=ç
   - Dead key entry points in symbols layer:
     - grave key → enter dead-grave layer
     - tilde key → enter dead-tilde layer
     - (dead-circumflex TBD — no key assigned yet in keyd)

5. **Config layer** (accessed via esc hold):
   - Media keys: brightness up/down, volume up/down/mute, play/pause, next/prev
   - (Key assignments for media TBD — not in original keyd config)

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
- Media: `volu vold mute pp prev next brdu brdd`
