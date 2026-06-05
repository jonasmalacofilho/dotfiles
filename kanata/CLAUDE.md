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
- symbols layer (held or oneshot via right Command), step 1 = programming symbols. Ports keyd's
  `[symbols]` without relying on an AltGr OS layout; each key outputs directly: 1-5 give the shifted
  number symbols, and the letter block gives the brackets, parens, math/shell punctuation, backtick,
  backslash, caret and tilde. Backtick/tilde are emitted via `grv`/`S-grv` (the grave usage the OS
  maps to them here). Another small departure from keyd, which activated symbols from rightalt: on
  the Mac the layer key is right Command (`rmet`), so right Option stays a plain Option and no
  longer needs intercepting. Right Command no longer types Command (left Command still does).
- symbols layer step 2a = Portuguese acutes and cedilla, direct unicode: e=é a=á u=ú i=í o=ó on the
  letter keys, comma=ç. Each is a `(fork (unicode lower) (unicode UPPER) (lsft rsft))` so Shift
  selects the uppercase codepoint (a held unicode codepoint is not uppercased by the OS; see the
  unicode note under Decisions). Confirmed on turing in multiple apps. The `` ` ``/`~`/`^` keys on
  `j`/`m`/`n` keep emitting literal symbols (programming needs them); the dead keys go on the native
  `` ` `` key instead (step 2b below).
  - Uppercase ergonomics (debug-traced, not a bug): when rmet is just tapped, the symbols layer
    lives only on the oneshot timer (reset to the most recent chained oneshot's value on each press,
    200ms here) — holding Shift does NOT extend it. So the robust uppercase recipe is to **hold rmet
    and Shift together, then the letter** (both held = layer-while-held + real modifier, no timer
    involved). Tapping rmet then leisurely pressing Shift and the letter races the timer and yields
    e.g. E instead of É once the letter lands after the layer reverts; that's expected oneshot
    behaviour, matching how AltGr-style layers want the layer key held.
- symbols layer step 2b/2c = three dead keys (grave, tilde, circumflex), each an internal one-shot
  layer reproducing keyd's `altgr-intl` delegation. Entry keys, all in the symbols layer: the native
  `` ` `` key (leftmost on the number row) = `@grave-key` (unshifted -> dead grave à; Shift -> dead
  tilde ã/õ); Shift+6 = dead circumflex (â/ê/ô), with unshifted 6 = literal 6. Literal
  `` ` ``/`~`/`^` for programming stay on `j`/`m`/`n`, so a non-vowel after a dead key just types
  through (no literal-commit fallback). Lowercase confirmed on turing; **uppercase deferred** (see
  CASE below).
  - The `` ` `` dead key reaches kanata as `lsgt`, not `grv`: the ISO backtick fix's grv<->lsgt swap
    makes the `lsgt` slot the one that emits a literal backtick, so `@grave-key` sits on the
    _second_ entry of the symbols-layer grv/lsgt pair. (First wiring put it on `grv` and the key
    fell through to a literal `` ` ``.)
  - **CASE (and why uppercase is deferred):** a kanata one-shot carries the modifiers held when it
    activates onto the key that consumes it. Grave is entered with **no** Shift, so nothing is
    carried and its fork does both cases: à = `` ` `` a; À = `` ` `` Shift+a. Tilde and circumflex
    are entered **with** Shift (`~` = Shift+`` ` ``, dead `^` = Shift+6), so that Shift is carried
    onto the vowel however quickly it is released — the vowel is permanently "shifted" and the case
    is locked, fork direction notwithstanding. We pick the locked case = lowercase by **inverting**
    those forks (upper codepoint on the never-reached no-Shift branch). So ã/õ/â/ê/ô work; Ã/Õ/Â/Ê/Ô
    do not yet. (Confirmed empirically: normal fork -> always Ã, inverted -> always ã; nothing in
    kanata cleanly prevents the carry for a layer one-shot — checked one-shot variants, `unmod`,
    chords.)
  - **Uppercase plan:** bring back Caps Lock (planned, toggled from the nav layer's left Shift) and
    have the dead-vowel forks read Caps for case. Caps is a toggle _state_, not a carried modifier,
    so it is immune to the one-shot carry. This also has to handle the acutes/cedilla, whose unicode
    output already ignores Caps Lock (they fork on Shift only) — revisit all of them together.

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
- `(unicode ...)` on macOS (kanata 1.11.0) is the one output path that does NOT go through the
  Karabiner VHID: `send_unicode` builds a `CGEvent`, attaches the codepoint via
  `CGEventKeyboardSetUnicodeString`, and posts it with `CGEventPost` (`src/oskbd/macos.rs`). Every
  other action writes a `DKEvent` to the virtual HID driver. Consequences:
  - It needs no special OS input source (the old "switch to Unicode Hex Input / ABC Extended" advice
    is obsolete for this codepath); the US layout and ISO backtick fix are untouched.
  - Posting synthetic events via `CGEventPost` requires the Accessibility (TCC) right. kanata is a
    sudo'd CLI with no TCC identity, so macOS attributes it to the _responsible process_ — the
    terminal that launched it (kitty here). The first `(unicode)` keypress prompts to grant
    **kitty** Accessibility; granting it makes unicode work. The earlier remaps never prompted
    because they use the VHID path. When kanata moves to a launchd autostart it becomes its own
    responsible process, so Accessibility will need granting to kanata/the daemon instead (revisit
    at the autostart step).
  - Because the codepoint is injected literally, a held Shift does not uppercase it; uppercase needs
    its own codepoint, which is why the accents use `fork` on `(lsft rsft)`.
  - The v1.8.0 unicode NUL-byte regression (issue #1546) was fixed by PR #1604, included since well
    before v1.11.0, so our build is unaffected.
- Characters needed for Brazilian Portuguese:
  - Acute: á é í ó ú (+ uppercase)
  - Tilde: ã õ (+ uppercase), via dead-tilde layer
  - Circumflex: â ê ô (+ uppercase), via dead-circumflex layer
  - Grave: à (+ uppercase), via dead-grave layer
  - Cedilla: ç Ç (direct)

#### Alternative not taken: lean on the macOS US-layout Option dead keys

Instead of reimplementing dead keys in kanata, we could route to the dead keys macOS already
provides in its US layout: Option+e = dead acute, Option+i = dead circumflex, Option+n = dead tilde,
Option+\` = dead grave, Option+u = dead umlaut, each then composing with the next vowel (and the OS
handles case from Shift natively, sidestepping our whole carried-Shift problem). kanata would just
need right Option (`ralt`) + the letter to reach the OS as Option+letter, e.g. ralt+e -> dead ´,
ralt+i -> dead ^, ralt+n -> dead ~. Worth keeping in mind. Caveats:

- It is macOS-specific: there is no equivalent on Linux, so it would not survive the eventual
  cross-platform goal (the kanata-internal dead keys do). Also unclear how cleanly kanata could even
  express "send Option+letter and let the OS compose" portably.
- kitty is set to map Option to Alt (`macos_option_as_alt`) for better Linux-CLI compatibility, so
  inside kitty (where most typing happens) the OS Option dead keys are not available at all — there
  we would still need our reimplementation. The native approach would only help outside kitty.

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

2. **Symbols layer — dead-key uppercase** (the dead keys themselves are done; see "tested and
   working"). All three dead layers exist: grave on the native `` ` `` key (unshifted), tilde on
   Shift+`` ` ``, circumflex on Shift+6 (`6` was added to `defsrc` for this, so every layer's number
   row gained a sixth slot). Grave does both cases; **tilde and circumflex are lowercase-only** for
   now because the one-shot carries the entry Shift onto the vowel (full explanation under "tested
   and working" → CASE). Remaining:
   - Uppercase Ã/Õ/Â/Ê/Ô. Blocked on bringing back **Caps Lock** (item 3 below): switch the
     dead-vowel forks (and likely the acutes/cedilla too) to read Caps for case, since Caps is a
     toggle state the one-shot can't carry. Do all the accented letters together.

3. **Caps Lock** — removed when the Caps key became `@cap` (tap Esc / hold nav). Bring it back as a
   toggle, planned binding: the nav layer's left Shift (`nav[lsft]`). Needed both for normal Caps
   Lock use and as the uppercase mechanism for the unicode accented letters (item 2).

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
