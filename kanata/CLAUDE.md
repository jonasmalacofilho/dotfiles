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

### File conventions

The config follows a few formatting and naming conventions; keep edits consistent with them.

- **Comment width.** A `;; vim: ft=lisp tw=100` modeline closes the file, and prose comments are
  wrapped to 100 columns. Left verbatim (never reflowed): the ASCII layout diagram in the
  symbols-layer comment, bullet lists, and the aligned dead-key entry table.
- **Grid alignment.** `defsrc` and every `deflayer` share one column grid. Each cell is padded to a
  uniform fixed-width stride (currently 7 chars, the widest token plus one space), so a given
  physical key sits in the same column across `defsrc` and all layers, and even the widest 14-key
  row stays under 100. Re-pad the whole grid after an edit if the widest token changes.
- **Alias names stay <= 5 chars** (<= 6 with the `@`) so any alias fits one grid cell without
  widening the shared stride. Scheme:
  - Accented letters are `<vowel><accent>`, accent one of `acu` (acute), `grv` (grave), `cir`
    (circumflex), `til` (tilde): e.g. `aacu` = á, `agrv` = à, `acir` = â, `atil` = ã. Cedilla is
    `cced`.
  - Dead-key one-shot layers are `d<accent>`: `dgrv` `dtil` `dcir`. `gkey` is the grave/tilde entry
    fork on the `bktk` key (replaces the old `grave-key`).
  - Overloads and oneshots: `cap` `esctl` `fnl`, `olsft`/`orsft` (oneshot Shift), `osym` (oneshot
    symbols), `rdel` (ralt+Backspace forward delete).

### What's tested and working

- `defsrc` models the whole MacBook ISO keyboard (every physical key, in a six-row grid; Touch
  ID/power omitted). Keys we don't remap are `_` passthrough in every layer, so behavior is
  unchanged but adding a future remap needs no `defsrc`/layer churn. The two ISO oddities: on turing
  macOS reports the backtick key (left of 1) and the `<>` key (left of z) with swapped scancodes, so
  a `deflocalkeys-macos` block names them `bktk` and `iso` (see "ISO scancode swap" under
  Decisions); `bksl` = the `#`/`~` key left of Enter. Validate edits offline with
  `kanata --check -c kanata.kbd` (also catches any layer whose entry count drifts from `defsrc`).
  Needs a light revisit when the Aula F75 (ANSI, fewer keys) is wired in.
- `fn` ↔ `lctl` swap (fn/Globe and Control keys swapped)
- `caps` tap=Esc, hold=nav layer (using `tap-hold-press` at 200ms)
- nav layer (held via caps): hjkl=arrows, yuio=home/pgdn/pgup/end, plus editing keys p=forward
  delete, bspc=delete word back, ret=Shift+Enter, '=". The bspc binding is `A-bspc` (macOS
  Option+Backspace); a `NOTE:` in the config flags that Linux wants `C-bspc` instead.
- forward delete on Backspace (the MacBook lacks a forward-delete key, and the fn<->lctl swap took
  native fn+Backspace with it). Two routes back: `fn+bspc` is restored in the fnrow layer
  (`fnrow[bspc]` = `del`, MacBook-only); `ralt+bspc` is cross-platform via
  `(fork bspc (unmod del) (ralt))` on the default-layer `bspc`. The `unmod` strips the held right
  Option so the OS gets a bare Delete, not Option+Delete (which macOS reads as delete-word-forward);
  confirmed stripping works on turing. Plain Backspace and `ralt` as a real Option (the macOS dead
  keys) are both unaffected.
- ISO backtick fix, now via `deflocalkeys-macos`: the block names the swapped physical keys
  (`bktk`/`iso`), and the default layer outputs `grv`/`lsgt` from them, so the backtick key sits
  left of 1. This replaced the former in-layer `grv`↔`lsgt` swap (see "ISO scancode swap" under
  Decisions for why a plain `deflocalkeys` rename did not work).
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
  `j`/`m`/`n` keep emitting literal symbols (programming needs them); the dead keys go on the `bktk`
  (backtick) key instead (step 2b below).
  - Uppercase ergonomics (debug-traced, not a bug): when rmet is just tapped, the symbols layer
    lives only on the oneshot timer (reset to the most recent chained oneshot's value on each press,
    200ms here) — holding Shift does NOT extend it. So the robust uppercase recipe is to **hold rmet
    and Shift together, then the letter** (both held = layer-while-held + real modifier, no timer
    involved). Tapping rmet then leisurely pressing Shift and the letter races the timer and yields
    e.g. E instead of É once the letter lands after the layer reverts; that's expected oneshot
    behaviour, matching how AltGr-style layers want the layer key held.
- symbols layer step 2b/2c = three dead keys (grave, tilde, circumflex), each an internal one-shot
  layer reproducing keyd's `altgr-intl` delegation. Entry keys, all in the symbols layer: the `bktk`
  (backtick, left of 1) key = `@gkey` (unshifted -> dead grave à; Shift -> dead tilde ã/õ);
  unshifted 6 = dead circumflex (â/ê/ô). Literal `` ` ``/`~`/`^` for programming stay on
  `j`/`m`/`n`, so a non-vowel after a dead key just types through (no literal-commit fallback).
  Confirmed on turing; grave and circumflex do both cases, but **tilde uppercase is deferred** (see
  CASE below).
  - `@gkey` sits on `bktk` (the backtick key, left of 1). That physical key reports OsCode 86, which
    `deflocalkeys-macos` names `bktk`; without the rename it would decode as `lsgt`.
  - **CASE (and why tilde uppercase is deferred):** a kanata one-shot carries the modifiers held
    when it activates onto the key that consumes it. Grave and circumflex are entered with **no**
    Shift, so nothing is carried and their forks do both cases: à = `` ` `` a, À = `` ` `` Shift+a;
    â = `6` a, Â = `6` Shift+a. Tilde is entered **with** Shift (`~` = Shift+`` ` ``), so that Shift
    is carried onto the vowel however quickly it is released — the vowel is permanently "shifted"
    and the case is locked, fork direction notwithstanding. We pick the locked case = lowercase by
    **inverting** its forks (upper codepoint on the never-reached no-Shift branch). So ã/õ work; Ã/Õ
    do not yet. (Confirmed empirically: normal fork -> always Ã, inverted -> always ã; nothing in
    kanata cleanly prevents the carry for a layer one-shot — checked one-shot variants, `unmod`,
    chords. Moving circumflex to unshifted 6 sidesteps the carry entirely, which is why Â/Ê/Ô now
    work.)
  - **Uppercase plan:** bring back Caps Lock (planned, toggled from the nav layer's left Shift) and
    have the tilde forks read Caps for case. Caps is a toggle _state_, not a carried modifier, so it
    is immune to the one-shot carry. This also has to handle the acutes/cedilla, whose unicode
    output already ignores Caps Lock (they fork on Shift only) — revisit all of them together.

---

## Decisions Made

### General

- macOS-first; only runs on macOS for now, but cross-platform deltas with Linux are noted inline as
  they come up (e.g. nav `bspc` and `ralt+bspc`), not yet exercised
- QWERTY only (no layout switching)
- no home row mods (not in use on Linux, can be added at a later point)
- `tap-hold-press` is the right variant for overload-style behavior (hold triggers on next key
  press, not just timeout) — matches keyd's `overload`
- for now, kanata is run as: `sudo kanata --cfg ~/.config/kanata/kanata.kbd`

### ISO scancode swap (deflocalkeys)

On turing, macOS reports the backtick key (left of 1, labelled `^`) as OsCode 86 and the ISO `<>`
key (left of z, labelled `<`) as OsCode 41 — the inverse of the usual ISO assignment (`grv` = 41,
`lsgt` = 86). The fix is a `deflocalkeys-macos` block, the idiomatic place to isolate a per-OS
scancode quirk so `defsrc` and the layers stay portable.

The non-obvious part, found by testing: **`deflocalkeys` maps a name to a scancode for both input
and output**, not input only. So renaming `grv` to 86 also made `grv` _output_ 86, which broke the
literal backtick and the symbols layer (anything emitting `grv` typed `§`). The working design names
the two physical keys with **custom** names instead — `bktk` (backtick key) and `iso` (the `<>` key)
— leaving `grv`/`lsgt` as untouched output names. The default layer then remaps `bktk -> grv` and
`iso -> lsgt` to emit the right characters. This is portable: `bktk -> grv` types a backtick on any
OS, and the scancode difference lives only in `deflocalkeys`.

Cross-platform follow-up: when the Aula (ANSI, Linux) is wired in, add a `deflocalkeys-linux`
mapping `bktk`/`iso` to their Linux codes (left-of-1 grave = 41; the Aula has no `<>` key), since
`defsrc` now uses those custom names.

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

#### Related: the macOS US-layout Option dead keys (and emulating them in kanata for Linux)

macOS's own US layout already provides dead keys on Option: Option+e = dead acute, Option+i = dead
circumflex, Option+n = dead tilde, Option+\` = dead grave, Option+u = dead umlaut, each composing
with the next vowel, with the OS handling case from Shift natively (none of our carried-Shift
problem). kanata does not intercept right Option (`ralt`) — only `rmet` drives the symbols layer —
so `ralt` passes straight through as a real Option, and ralt+e/i/n/... just work as the macOS dead
keys, no kanata accent layer involved. And with `macos_option_as_alt left` in kitty
(`kitty/turing.conf`), right Option stays a native Option inside kitty too (left Option remains Alt
for Linux-CLI compatibility), so this is usable where most typing happens. So on macOS this is
available essentially for free, alongside our symbols-layer reimplementation.

It is macOS-only, though: there is no OS-level equivalent on Linux. For the eventual cross-platform
goal, the idea is to emulate the same _ergonomics_ in kanata itself — ralt+letter entering a dead
layer that `fork`+`unicode`s the accented codepoint — rather than relying on OS compose. That is
essentially our existing dead-key machinery, just keyed off ralt+letter macOS-style (e=acute,
i=circumflex, n=tilde, \`=grave, u=umlaut) instead of the symbols-layer `` ` `` key and 6 key. Such
an emulation would run on both platforms and not depend on OS compose; the native macOS Option dead
keys would then just be a redundant convenience on the Mac. A bonus: every macOS-style trigger
(Option+e/i/n/\`/u) is **unshifted**, so the dead layer would be entered without Shift and nothing
would be carried onto the vowel — case would come cleanly from Shift at the vowel and uppercase
would work for free, no Caps Lock needed (unlike our current Shift+`` ` `` tilde, the one accent
still entered shifted). That makes this a candidate not just for Linux but as a uppercase fix on
macOS too.

### Function keys / media keys

- Known limitation: Karabiner virtual keyboard breaks fn+Fkey media control behavior — fn key state
  is lost through the virtual HID device
- Solution: map media keys (brightness, volume) explicitly rather than relying on fn+Fkey. Volume
  and playback are on F7-F12 in both the control and fnrow layers; brightness is on F1/F2 in the
  fnrow layer (the control layer omits it, since that layer targets non-Mac keyboards).

### Multiple keyboards

- An ANSI US mechanical keyboard will be added later
- Plan: single kanata config, single instance; differences between keyboards are small enough
  (mainly the fn key swap, which the mech won't need)
- Revisit when the mech is actually connected

---

## Features Still To Port (from keyd)

In rough priority order:

1. **Nav layer — remaining keys.** Only hjkl/yuio are mapped so far. The Linux source to port is
   `common`'s `[nav]` _merged with_ `nav_mods`'s `[nav]` overrides (every machine includes both;
   `home_row_mods` stays off unless toggled from the config layer). Triaged 2026-06-05:
   - **Added (done; see "tested and working" above):** `p` = `del`, `bspc` = `A-bspc` (macOS
     word-delete; Linux wants `C-bspc`), `ret` = `S-enter`, `'` = `"`.
   - **Dropped:**
     - kitty `e` = `C-{`, `r` = `C-}`: overridden by `nav_mods` on Linux, so never actually active
       (hence keyd's "maybe no longer in use"); kitty's Mac bindings differ anyway.
     - `f1` = `layer(config)`: the control layer is already reachable via esc-hold on the Mac.
       Revisit only when the Aula (firmware-Esc edge case) is wired in.
   - **Deferred (open decisions):**
     - **Home-row mod activators** `s`/`d`/`f`/`g`/`space`/`t` (keyd: meta/alt/control/shift). The
       point is modified arrows (e.g. word-left). macOS modifier semantics differ from Linux:
       word-wise = **Option**+arrow (not Ctrl), line/doc = **Cmd**+arrow, and **Ctrl+arrow is taken
       by Mission Control / Spaces** — so a literal `f`=Control port switches spaces instead of
       jumping words. Open: macOS-semantic remap (preserve the action: d=Option, s=Cmd) vs literal
       port vs drop. Implementation note: kanata needs no keyd `layer(meta)` machinery — a bare
       modifier on the key in the nav layer (e.g. `f` -> `lctl`) composes with `h` -> `left` to emit
       the combo.
     - **Shift+nav selection sublayers** `w`/`e`/`r` -> `S-mod-`+arrows (keyd's
       `nav-mods-shift-{meta,alt,control}`). Experimental in the source; same modifier-semantics
       issue, three layers deep. Drop vs rebuild minimally for shifted word/line selection.
     - `a` = `q` = noop in keyd's nav (dead-keyed to avoid misfires when reaching for the home-row
       mods). Tied to the mod-activator question; defer with it. Until then they stay passthrough.
   - **Belongs with item 3:** `rightshift` = `capslock` (keyd put Caps here; this doc floats
     `nav[lsft]`). Decide with the Caps Lock work.

2. **Symbols layer — dead-key uppercase** (the dead keys themselves are done; see "tested and
   working"). All three dead layers exist: grave on the `bktk` (backtick) key (unshifted), tilde on
   Shift+that key, circumflex on unshifted 6. Grave and circumflex do both cases; **tilde is
   lowercase-only** for now because the one-shot carries the entry Shift onto the vowel (full
   explanation under "tested and working" → CASE). Remaining:
   - Uppercase Ã/Õ. Blocked on bringing back **Caps Lock** (item 3 below): switch the tilde forks
     (and likely the acutes/cedilla too) to read Caps for case, since Caps is a toggle state the
     one-shot can't carry. Do all the accented letters together.

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
