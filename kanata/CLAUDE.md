# Kanata Keyboard Layout

## Context

Porting a keyd keyboard layout (Linux) to kanata (macOS) for a MacBook Pro M5 (hostname: turing,
Apple Silicon, ISO keyboard). kanata is already installed via Homebrew. The Karabiner DriverKit
VirtualHIDDevice v6.x driver is installed and activated; the VHID manager, VHID daemon, and kanata
itself now **autostart as system LaunchDaemons** (installed via `just kanata install`, see
"Operational Setup").

Relevant paths:

- source keyd config (but consider "Decisions Made"): `~/Code/etcfiles/keyd/`
- kanata config: this directory in the dotfiles repo. The daemon does not read it directly — it
  reads a root-owned copy staged from here (see "Operational Setup").

---

## Hardware & Keyboards

Two physical keyboards in play; one kanata config is meant to serve both (see "Multiple keyboards").

### MacBook Pro M5 (turing) — primary

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
  delete, bspc=delete word back, ret=Shift+Enter, '=", x/c/v=cut/copy/paste. The bspc binding is
  `A-bspc` (macOS Option+Backspace); a `NOTE:` in the config flags that Linux wants `C-bspc`
  instead. The left hand scales movement with held mods: d=Option (word/paragraph), f=Cmd
  (line/document edge), spc=Shift (selection, composing with d/f); a/s/g are no-ops. All
  hardware-confirmed.
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
  plain modifiers for now. The accent layers override this per the dead-key CASE note: Shift is
  plain in the symbols layer (so the tilde entry Shift has no oneshot tail) and one-shot again
  inside the dead layers (so a post-entry Shift chains rather than dropping the dead key).
- esc: tap = Esc, hold = control layer (overload, 200ms), same pattern as caps
- control layer (held via esc): media + volume on the Mac's F7-F12 (prev / play-pause / next, mute,
  vol- / vol+), plus Mission Control (F3) and Spotlight (F4). keyd's equivalent layer was empty, so
  this is new; the macOS-specific Mission Control/Spotlight usages (mctl/sls) work here.
- control-layer F5 = live config reload (kanata `lrld`); an invalid reload is rejected and the
  running config is kept. Since the daemon reads a root-owned copy (see "Operational Setup"), the
  workflow is: edit source, `just kanata sync-config` (re-stages the copy and restarts kanata).
  esc+F5 still rereads kanata's `--cfg`, but that is now the root-owned copy, so it only reflects an
  edit once `sync-config` has staged it.
- moved fn key (the physical Control-labelled key) tap = fn, hold = a real held fn modifier PLUS the
  fnrow overlay, via `(multi fn (layer-while-held fnrow))`. Phase-0 testing split the fn shortcuts
  in two (see "Function keys / media keys"): the held fn drives the macOS **global hotkeys**
  straight through the VHID (fn+A Dock, fn+C Control Center, fn+N Notification Center, fn+Q Quick
  Note, fn+H show desktop, fn+Shift+A Apps, fn+Ctrl+F window fill — all confirmed), while the fnrow
  overlay reproduces the fn **key-transforms** the VHID-emitted fn can't drive: F1/F2 brightness, F3
  Mission Control, F4 Spotlight, F5 Dictation, F6 Do Not Disturb, F7-F12 media/volume; arrows ->
  PageUp/PageDown/Home/End (fn+arrow); bspc -> del (fn+Delete); e -> Ctrl+Cmd+Space (fn+E emoji, via
  `@emoji`). Keys the held fn handles stay passthrough in fnrow so the OS sees fn+<key>; the
  overridden keys carry a harmless extra fn flag (confirmed not to disturb them). For the MacBook's
  own keyboard; other keyboards use the control layer instead. F5/F6 assume the modern layout (else
  `bldn`/`blup` for keyboard backlight). All confirmed working through the VHID on turing.
- symbols layer (held or oneshot via right Command), step 1 = programming symbols. Ports keyd's
  `[symbols]` without relying on an AltGr OS layout; each key outputs directly: 1-5 give the shifted
  number symbols, and the letter block gives the brackets, parens, math/shell punctuation, backtick,
  backslash, caret and tilde. Backtick/tilde are emitted via `grv`/`S-grv` (the grave usage the OS
  maps to them here). Another small departure from keyd, which activated symbols from rightalt: on
  the Mac the layer key is right Command (`rmet`), so right Option stays a plain Option and no
  longer needs intercepting. Right Command no longer types Command (left Command still does).
- symbols layer step 2a = Portuguese acutes and cedilla, direct unicode: e=é a=á u=ú i=í o=ó on the
  letter keys, comma=ç. Each is `(fork <noshift-caps-switch> (unicode UPPER) (lsft rsft))`: Shift
  selects the uppercase codepoint (a held unicode codepoint is not uppercased by the OS; see the
  unicode note under Decisions), and the no-Shift branch reads the `capsvk` Caps-Lock flag, so case
  is Shift-OR-Caps (item 2). Confirmed on turing in multiple apps. The `` ` ``/`~`/`^` keys on
  `j`/`m`/`n` keep emitting literal symbols (programming needs them); the dead keys go on the `bktk`
  (backtick) key instead (step 2b below).
  - Uppercase ergonomics: hold `rmet` and Shift together, then the letter. Shift is now a plain
    modifier inside the symbols layer (it used to be a oneshot whose 200ms tail caused timer races
    and the tilde carry — see item 2 / the dead-key CASE note), so held Shift cleanly selects
    uppercase. Tapping `rmet` instead of holding it still leaves the symbols layer on its own 200ms
    oneshot timer, so holding `rmet` stays the robust habit.
- symbols layer step 2b/2c = three dead keys (grave, tilde, circumflex), each an internal one-shot
  layer reproducing keyd's `altgr-intl` delegation. Entry keys, all in the symbols layer: the `bktk`
  (backtick, left of 1) key = `@gkey` (unshifted -> dead grave à; Shift -> dead tilde ã/õ);
  unshifted 6 = dead circumflex (â/ê/ô). Literal `` ` ``/`~`/`^` for programming stay on
  `j`/`m`/`n`, so a non-vowel after a dead key just types through (no literal-commit fallback).
  Confirmed on turing. Case handling went through several iterations (item 2 in "Features Still To
  Port") and settled on **Shift-OR-Caps for all three dead keys**, matching macOS (Caps + Shift
  stays uppercase). Tilde uppercase (Ã/Õ) is no longer deferred. All hardware-confirmed.
  - `@gkey` sits on `bktk` (the backtick key, left of 1). That physical key reports OsCode 86, which
    `deflocalkeys-macos` names `bktk`; without the rename it would decode as `lsgt`.
  - **CASE (Shift handling, settled).** All three dead keys read Shift-OR-Caps. Two opposite Shift
    subtleties fall out of one kanata rule — a one-shot is consumed by any non-one-shot key; only
    other one-shots chain with it:
    - **Tilde** enters WITH Shift (`~` = Shift+`` ` ``). The old "always Ã, can't get ã" was the
      default-layer **oneshot** Shift's 200ms tail chaining through the deadtilde one-shot onto the
      vowel — a debug capture caught a rare ã when the vowel landed after the tail expired, proving
      it was the oneshot tail, not a physical-hold carry (this corrects the earlier claim here).
      Fix: the **symbols layer makes Shift a plain modifier**, so there is no tail — hold Shift
      through the vowel for Ã/Õ, release before for ã/õ.
    - **Grave** enters UNSHIFTED (Shift+bktk is the tilde fork), so its uppercase Shift can only
      come AFTER entry, and a plain Shift there _consumed_ the deadgrave one-shot, landing on the
      symbols acute (À -> Á). Fix: **lsft/rsft are one-shot Shift inside the three dead layers**
      (`@olsft`/`@orsft`), so a post-entry or switched-hand Shift chains with the dead-key one-shot
      instead of consuming it. Small cost: a ~200ms window to land the vowel after pressing Shift.
    - **Circumflex** dodges both: unshifted entry on 6 with Shift simply held from before.
  - **Caps Lock path (independent of Shift):** `@cpsl` (`nav[rsft]`) mirrors the OS Caps Lock into
    the `capsvk` virtual key, which each accent's no-Shift fork branch reads — so Caps Lock
    uppercases any accent without touching Shift. See item 3 for the mirror and its reload-off
    gotcha.

---

## Decisions Made

### General

- macOS-first; only runs on macOS for now, but cross-platform deltas with Linux are noted inline as
  they come up (e.g. nav `bspc` and `ralt+bspc`), not yet exercised. When the config does go
  cross-platform, kanata can branch _actions_ per OS within one file, so the noted deltas become
  real per-OS definitions behind a single shared `deflayer` rather than hand-edited swaps. Two
  mechanisms, in order of preference:
  - **`(platform (macos) ...)`** (also `linux`, `win`/`winiov2`/`wintercept`, combinable like
    `(platform (macos linux) ...)`) wraps any top-level item for the given OSes. This is the right
    tool for pure per-OS branching: kanata knows its own platform, so there is no env var to set and
    no `sudo` issue. Verified valid in 1.11.0.
  - **`(environment (VAR value) ...)`** (older alias-only form: `defaliasenvcond`) keys on an env
    var read once at startup — for distinctions `platform` can't express (which machine, which
    keyboard variant on the _same_ OS). Caveat: `sudo` scrubs the environment, so the var needs
    `sudo VAR=... kanata`, `sudo -E`, or the launchd plist's `EnvironmentVariables`.

  Both are separate from `deflocalkeys`, which only renames scancodes (and globally per OS, not per
  device — see "Multiple keyboards").
- QWERTY only (no layout switching)
- no home row mods (not in use on Linux, can be added at a later point)
- `tap-hold-press` is the right variant for overload-style behavior (hold triggers on next key
  press, not just timeout) — matches keyd's `overload`
- kanata runs as a root LaunchDaemon reading a root-owned config copy (see "Operational Setup"); the
  earlier `sudo kanata --cfg <path>` foreground invocation is now only the manual-debug fallback

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
    its own codepoint, which is why the accents pick case explicitly (a `fork` on `(lsft rsft)` for
    Shift, plus a `switch` on the `capsvk` virtual key for Caps Lock).
  - **macOS Caps + Shift = uppercase (case semantics).** macOS keeps letters uppercase when Shift is
    held with Caps Lock on (Shift then only affects numbers/punctuation), with no setting to invert
    — unlike Linux/Windows, where Shift cancels Caps to lowercase. So the accents uppercase on Shift
    **OR** Caps (not XOR), to agree with every normal letter on the Mac. Making normal letters do
    XOR would mean re-casing every alpha key in kanata (impractical), so OR is the consistent
    choice. Cross-platform follow-up: Linux would want XOR instead.
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

- The fn/Globe key splits in two over the Karabiner VHID (Phase-0 tested on turing, MacBook Pro M5,
  Tahoe 26). kanata maps `fn` to the AppleVendor top-case usage (page `0xFF`, code `0x03`) — the
  same usage Karabiner-Elements uses — so a VHID-emitted fn:
  - **works as the Globe modifier flag** for macOS **global hotkeys**: fn+A (Dock), fn+C (Control
    Center), fn+N (Notification Center), fn+Q (Quick Note), fn+H (show desktop), fn+Shift+A (Apps),
    fn+Ctrl+F (window fill). The held fn from `@fnl` covers these for free, no per-key mapping.
  - **does NOT drive the low-level fn key-transforms** the OS does for the built-in keyboard:
    fn+Fkey -> media, fn+arrow -> PageUp/Home/End, fn+Delete -> forward delete, and fn+E -> emoji
    all arrive untransformed. This corrects the earlier blanket "fn state is lost through the VHID"
    note: it is lost only for this transform class, not the modifier-flag class. F7/F8 are the
    starkest case — they emit nothing usable, having no consumer-page equivalent.
- Solution: the `fnrow` overlay reproduces the dead transforms explicitly — brightness on F1/F2,
  Mission Control/Spotlight/Dictation/DND on F3-F6, media/volume on F7-F12, arrows -> nav, bspc ->
  del, e -> Ctrl+Cmd+Space — while the global-hotkey keys ride the held fn. Volume and playback are
  also on F7-F12 in the control layer (the non-Mac-keyboard path); brightness is fnrow-only, since
  the control layer targets boards with no fn key.
- Window tiling: fn+Ctrl+F (fill) works, but the **halves/quarters** (fn+Ctrl+arrow) cannot — the
  arrow loses its fn flag in the same transform gap, so WindowServer sees a bare Ctrl+arrow. Getting
  them would mean assigning custom non-fn shortcuts to the Window-menu items (System Settings >
  Keyboard > Keyboard Shortcuts > App Shortcuts) and binding those; not done.

### Multiple keyboards

The mech is the Aula F75 (75% ANSI/US), to be used alongside the MacBook's built-in ISO keyboard on
turing — so this is **two keyboards on one Mac** (both seen by macOS), not the cross-platform/Linux
scenario. Goal: one kanata setup serving both despite small layout differences. Not wired in yet;
researched 2026-06-07.

**Device identities** (`kanata --list` shows names + hashes; `definputdevices` also matches
`vendor_id`/`product_id`):

| Device                                                  | Match by                                                             | Source              |
| ------------------------------------------------------- | -------------------------------------------------------------------- | ------------------- |
| MacBook internal                                        | name `Apple Internal Keyboard / Trackpad`; hash `0xD4359520DA829EC8` | `kanata --list`     |
| Karabiner VHID (never grab — it is kanata's own output) | name `Karabiner DriverKit VirtualHIDKeyboard 1.8.0`                  | `kanata --list`     |
| Aula F75 — wired                                        | `vendor_id 0x258a product_id 0x010c` (9610 / 268)                    | keyd `aulaf75.conf` |
| Aula F75 — 2.4 GHz dongle                               | `vendor_id 0x3554 product_id 0xfa09`                                 | keyd                |
| Aula F75 — Bluetooth 5.0                                | `vendor_id 0x3554 product_id 0xfa07`                                 | keyd                |
| Aula F75 — Bluetooth 3.0                                | `vendor_id 0x3554 product_id 0xfa08`                                 | keyd                |

The Aula's per-mode _name_ and _hash_ (needed for `macos-dev-names-include`) can only be read with
it connected.

**Differences that actually need handling** (most keys overlap; unmatched scancodes pass through via
`process-unmapped-keys yes`):

1. **fn<->lctl swap — the one same-scancode/different-action conflict.** The MacBook maps physical
   Control to `@fnl` (tap fn / hold fnrow) and physical fn to Control. The Aula has no OS-visible fn
   (firmware-only); its bottom-left sends plain `lctl`. So the `lctl` scancode must mean Control on
   the Aula but `@fnl` on the MacBook — one scancode, two behaviors. The rest of the Aula bottom row
   is fine (super -> `lmet`/Command, alt -> `lalt`/Option, right-Control passthrough; the `fn`
   defsrc slot is dormant on the Aula since it never sends `fn`).
2. **ISO vs ANSI scancodes, and `deflocalkeys` is global.** `deflocalkeys-macos` renames the
   MacBook's backtick (OsCode 86) and ISO `<>` (41) to `bktk`/`iso`. `deflocalkeys` is per-OS and
   global (input+output), with **no per-device form in any kanata version**. Likely collision: the
   MacBook's `<>` and the Aula's backtick probably both arrive as OsCode 41 (`iso`), so the Aula's
   backtick would decode to `lsgt` (§). Partly resolvable (see option C), but the exact Aula codes
   are an open empirical question.

**Three options** (verified against installed kanata 1.11.0, the latest stable):

- **A — single instance, `definputdevices` + `(device-history $id $recency)`.** The native
  per-device action selector; the docs' stated use case is exactly swapped-modifier positions across
  devices. Identify the MacBook and gate the `lctl` action: MacBook -> `@fnl`, default branch ->
  plain `lctl` (the default covers the Aula and any unknown board, so the four Aula IDs need not be
  enumerated). **Not in 1.11.0** (tested: "unknown configuration item"); it is in 1.12.0-prerelease
  / `main`. Caveats even then: devices matched at startup only (Aula must be connected before kanata
  starts; no hotplug, no re-read on live reload), press events only.
- **B — two instances, `macos-dev-names-include`.** Present in 1.11.0. One instance grabs only the
  MacBook with the current config; another grabs only the Aula with an ANSI-tailored config. Each
  instance has its _own_ `deflocalkeys`, so this **fully sidesteps delta 2**. Costs: two processes
  (launchd, kill switch), a shared single VHID to feed (confirm two instances coexist), `platform`
  or two files to stay DRY.
- **C — single instance, manual mode toggle (works on 1.11.0 today).** A virtual key is a mode flag;
  one key toggles it; conflicting actions read it via `switch` — the same `capsvk` pattern already
  in the config. Gate only the slots that differ:
  ```
  (defvirtualkeys aulavk nop0)
  (defalias
    mode (on-press toggle-virtualkey aulavk)
    lc   (switch ((input virtual aulavk)) lctl break () @fnl break))
  ```
  Then the default-layer `lctl` slot becomes `@lc`, and a `mode` key lives somewhere out of the way.
  **Verified valid in 1.11.0.** It can also reach into delta 2 — not by toggling `deflocalkeys`
  (impossible), but by mode-gating what a shared `defsrc` slot _emits_: e.g. `iso` (OsCode 41) ->
  `lsgt` in Mac mode, `grv` (backtick) in Aula mode, since both keyboards likely send 41 there.
  Cons: it is manual (flip on swap, and flip back); virtual-key state resets to off on every config
  reload (same gotcha as `capsvk`); the scancode-gating depends on the Aula's real codes.

**Recommendation.** On 1.11.0 today, **C** is the best single-instance choice: minimal, fully shared
nav/symbols/accents, reuses a proven pattern, and the scancode-gating trick lets it handle delta 2
too. It is also a clean stepping stone to **A** — when 1.12.0 ships, swap the
`(input virtual
aulavk)` checks for `(device-history $id-mba 1)` and the manual toggle disappears;
the structure is otherwise identical. Reach for **B** only if the ISO/ANSI collision proves annoying
and you want it gone with zero manual steps, accepting the second process.

**Still needs the Aula connected:** its per-mode name/hash (`kanata --list`) and the actual
scancodes it emits on macOS for backtick and any relocated keys (to settle delta 2). Revisit then.

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
   - **Movement/selection mods (done 2026-06-07; hardware-confirmed).** Resolved the deferred
     mod-activator/selection/noop questions by _narrowing the goal_: not keyd's "any mod plus nav"
     over-reach, just text movement and selection. On macOS one modifier spans both axes, so two
     movement mods and Shift cover the whole char/word/paragraph/line/document grid in move and
     select. The left hand drives them (it already holds caps); the right hand stays on hjkl:
     - `d` = `lalt` (Option) gives word (h/l) and paragraph (j/k); `f` = `lmet` (Cmd) gives line
       edge (h/l) and document edge (j/k); `spc` = `lsft` (Shift, on the thumb) gives selection,
       composing with d/f (`spc` `d` `l` = select word right). Plain modifiers, no keyd
       `layer(meta)` machinery. Shift on `spc` is keyboard-agnostic (the spacebar is always
       thumb-reachable, unlike the Aula's awkward thumb-modifier keys).
     - `a`/`s`/`g` = `XX` (no-op): holding caps pulls the left pinky off home; swallowing the keys
       under the reaching fingers stops a fumble leaking a stray letter. (keyd noop'd `a`/`q`.)
     - **Dropped the Shift+nav selection sublayers** (`w`/`e`/`r`, keyd's
       `nav-mods-shift-{meta,alt,control}`): redundant once `spc`=Shift is a real held modifier
       composing onto the d/f movement — selection is just `spc`, a movement mod, and an arrow.
     - **Cross-platform** branches within one config via `(platform ...)` blocks (see the General
       decision on cross-platform conditionals) selecting per-OS definitions behind this single
       `deflayer`, not hand-edited swaps: `d` -> `lctl` (Ctrl+arrows give word and paragraph) is
       trivial; `f` is not, since Linux/Win line=Home/End and doc=Ctrl+Home/End are dedicated keys,
       not a modifier, so `f` must become a `navline` `layer-while-held` (h->home, l->end,
       k->C-home, j->C-end) with `spc`=Shift composing for free (S-home/S-end). Full note in the
       nav-layer comment in `kanata.kbd`.
   - **Belongs with item 3 (resolved):** `rightshift` = `capslock` (keyd put Caps here; this doc
     floated `nav[lsft]`). Decided in favor of `nav[rsft]` = `caps` (right Shift within the nav
     layer, echoing keyd); see item 3.

2. **Symbols layer — dead-key uppercase — done (hardware-confirmed).** All three dead keys do
   Shift-OR-Caps (grave on `bktk` unshifted, tilde on Shift+`bktk`, circumflex on unshifted 6). The
   mechanism, settled after a few iterations:
   - **Caps Lock path.** `@cpsl` (the `nav[rsft]` Caps Lock) does
     `(multi caps (on-press
     toggle-virtualkey capsvk))`: it taps the OS Caps Lock _and_ mirrors
     the state into the `capsvk` virtual key (`(defvirtualkeys capsvk nop0)`), which a `switch` can
     read (`(input virtual
     capsvk)`) even though a `fork` and the OS Caps state cannot. Each
     accent is `(fork
     <noshift-caps-switch> <upper> (lsft rsft))`; the no-Shift branch reads
     `capsvk`, so Caps + Shift = uppercase, matching macOS. (We built XOR first, then switched to OR
     — see the Caps+Shift note under Decisions.)
   - **Shift path.** Two fixes, both from the kanata rule that a one-shot is consumed by any
     non-one-shot key and only other one-shots chain: (1) `symbols[lsft/rsft]` are plain Shift, so
     the tilde entry Shift has no oneshot tail to leak onto the vowel (hold through -> Ã/Õ, release
     -> ã/õ); (2) `lsft/rsft` inside the three dead layers are one-shot Shift, so the uppercase
     Shift grave needs _after_ its unshifted entry chains with the dead-key one-shot instead of
     consuming it (À), with a ~200ms window. Full reasoning under "tested and working" → CASE.
   - Tunable left open: that ~200ms dead-layer Shift window could get a dedicated longer one-shot if
     it ever feels tight in use.

3. **Caps Lock** — ~~removed when the Caps key became `@cap`~~ **done (hardware-confirmed)**. Bound
   to `nav[rsft]` = `@cpsl` = `(multi caps (on-press toggle-virtualkey
   capsvk))`: the physical
   Caps key holds nav (tap = Esc), so a real Caps Lock toggle returns on the right Shift while nav
   is held (hold caps, tap right Shift). This lands the toggle on the right Shift like keyd's
   `rightshift = capslock`, but scoped to the nav layer, so the default-layer `@orsft` oneshot on
   the right Shift is untouched.
   - **Item-2 hook (done):** `@cpsl` also mirrors the toggle into the `capsvk` virtual key
     (`(defvirtualkeys capsvk nop0)`), because a `fork` and the OS Caps state aren't readable but
     `(input virtual capsvk)` in a `switch` is. The accents read `capsvk` for case; see item 2.
   - **Gotcha — reload with Caps OFF.** `capsvk` and the OS Caps Lock are independent toggles kept
     in phase only by `@cpsl`. `capsvk` resets to off on every config load, but the OS Caps state
     persists across an `esc`+F5 reload, so reloading while Caps is ON inverts them (accents come
     out wrong-cased) and a tap can't resync (it flips both, preserving the error). Fix: Caps off,
     then reload. Decided 2026-06-06 to keep the real OS Caps Lock + mirror and adopt the reload-off
     habit, rather than a deterministic kanata-owned Caps (wanted later — see "Future ideas").
     kanata can't read the OS Caps state to self-correct.
   - **Known limitation — Caps LED stays dark.** kanata toggles caps through the Karabiner VHID,
     which never lights the MacBook's internal Caps Lock LED (kanata
     [#1364](https://github.com/jtroo/kanata/issues/1364); the maintainer has no Macs). Karabiner-
     _Elements_ has dedicated "Manipulate caps lock LED" code, but we run only the DriverKit VHID +
     kanata, and kanata has no macOS LED action. No clean config fix; accepted (use an on-screen
     caps indicator if feedback is wanted). Functionality is unaffected — only the LED.

---

## Future ideas (kanata-native, not from keyd)

Wanted later, explicitly out of scope for now (noted 2026-06-06):

- **kanata-owned Caps Lock.** Replace the OS-Caps-Lock + `capsvk` mirror (item 3) with a single
  kanata-internal state: `@cpsl` toggles `capsvk` plus a `caps` base-layer mapping
  `a..z -> S-a..S-z`, dropping the OS Caps Lock entirely. Deterministic across reloads — it removes
  the phase error that makes the mirror fragile today (item 3's gotcha) — at the cost of real OS
  Caps Lock (no OS caps-field warnings; the LED is already dead anyway).
- **caps-word.** Try kanata's `(caps-word ...)` (auto-shift the next word, releasing on
  space/punctuation) for the common "one capitalized token" case — as a lighter complement to, or
  partial replacement for, a full Caps Lock.
- **A held mod on `nav[s]`.** Give the currently-`XX` `s` a held-modifier role. Two distinct
  motivations want it, and they pull `s` in different directions, so the choice is between them
  (they coincide on macOS, diverge on Linux):
  - **Reach kitty_mod.** Fix `s` = `lctl` on _every_ OS. kitty's `kitty_mod` defaults to Ctrl+Shift
    everywhere, so `s` plus the existing `spc`=Shift would fire kitty bindings from the nav layer
    (caps + s + spc + key = Ctrl+Shift+key). Alternative if `s` is wanted for the use below instead:
    remap that one kitty combo to another key in kitty.
  - **Switch workspaces.** Compose with the hjkl arrows (`s`+h/l = prev/next space). On macOS this
    is also just `lctl` — Ctrl+←/→ is the default "move one space" binding, the very chord we kept
    _off_ the text-movement mods (Ctrl+arrow = Mission Control conflicts with caret nav, see the
    nav-layer comment), so `s` here turns that conflict into a feature and reclaims a no-op. On
    Linux it differs: GNOME/KDE workspace switch is Ctrl+Alt+←/→ (some setups Super+←/→ or
    Super+PgUp/Dn), so `s` would need Ctrl+Alt, not plain Ctrl — diverging from the kitty case
    above.
  - So on macOS both motivations land on `s` = `lctl` (no conflict); on Linux pick one, since
    kitty_mod wants plain Ctrl and workspace nav wants Ctrl+Alt. Either way the per-OS definition
    can branch within one config via `(platform ...)` (see the General decision on cross-platform
    conditionals), not a hand-edited swap.
- **Numpad layer.** A held or toggled layer turning the right-hand home cluster into a numeric
  keypad (e.g. `uiojklm,.` -> `789456123` with `0`/decimal nearby), for entering numbers without
  reaching the number row. Open questions: which key activates it (a free tap-hold, or a toggle so
  it stays on for a run of digits) and the exact key map. Keyboard-agnostic, so it would just live
  in the shared config.

## Operational Setup (not from keyd)

Three things must be running: the Karabiner VHID activation (one-shot), its VHID daemon, and kanata.
As of 2026-06-08 all three **autostart as root LaunchDaemons** installed via `just kanata install`.
The source plists, the install/manage justfile, the relaunch policy, and the TCC steps all live in
`./launchd/` — read `launchd/README.md` for the full detail; only the essentials are summarized
here.

- **Install/manage**: `just kanata <recipe>` from the repo root (`install`, `uninstall`, `status`,
  `logs`, `reload <label>`, `lint`, `check-config`, `sync-config`). The sudo-gated recipes touch
  `/Library/LaunchDaemons`, `/Library/Application Support/kanata`, and the system launchd domain.
- **Config is root-owned, not user-writable.** kanata runs as root, so the daemon reads a
  `root:wheel 0644` copy at `/Library/Application Support/kanata/kanata.kbd`, staged from the repo
  source (`kanata.kbd` in this directory). A config the login user could write would be a
  root-escalation path (moot for `cmd` since Homebrew's kanata is compiled to forbid it, but a root
  process driving the keyboard warrants it anyway). Editing `kanata.kbd` reaches the daemon via
  `just kanata sync-config` (`--check`, copy to the root-owned path, restart kanata). Cross-platform
  note: Linux will mirror this with kanata under a dedicated low-privilege `kanata` user and an
  equally root-owned config. See `launchd/README.md` → "Config file".
- **Relaunch policy**: the Karabiner daemon uses plain `KeepAlive`; kanata uses
  `KeepAlive { SuccessfulExit = false }`, so the kill switch (clean exit 0 since 1.11.0) drops you
  to the stock layout and stays down, while crashes (e.g. sleep/wake) self-heal. Relaunch kanata
  with `just kanata reload local.kanata` or `sudo launchctl kickstart system/local.kanata`.
- **TCC, manual and required** (the one thing the move off the terminal changes): as a daemon kanata
  is its own responsible process, so **Input Monitoring** (mandatory) and **Accessibility** (only
  for the `(unicode)` accents) must be granted to the binary at `/opt/homebrew/bin/kanata`, not to
  kitty. A daemon can't raise the prompt, so add both by hand in System Settings > Privacy &
  Security. See `launchd/README.md` for the re-add-to-fix and brew-upgrade-voids-grant gotchas.
- **Startup flags**: the plist runs kanata with `--no-wait` (a clean exit must not block the
  KeepAlive relaunch), `--quiet`, and `--nodelay`. `--quiet` is errors-only logging — see "Logs"
  below. `--nodelay` skips the 2s "release all keys" startup sleep, which guards an _interactive_
  launch against held keys sticking and is pointless for a boot daemon; kanata warns it can rarely
  cause cold-start keyboard issues, so drop it if a boot ever misbehaves.

### Logs

kanata writes stdout+stderr to `/var/log/kanata.log` (set in `local.kanata.plist`). Two things to
know: how much it logs, and why the file is hard to rotate safely. **The log contains config/layer
and status text, not keystrokes** (key events are debug/trace only), so its world-readable `0644` is
not a secrets concern.

- **Volume — handled by `--quiet`.** At the default Info level kanata logs the _entire_ `deflayer`
  block on every layer switch ("Entered layer: ..."), so a normal typing session piles up thousands
  of lines and the file grows without bound. `--quiet` (in the plist) drops to errors-only, keeping
  the diagnostics that matter — config-load failures, device/permission errors — and dropping the
  per-switch noise. The infamous 450 MB kanata log (discussion #1537) was `--debug` _plus_ a
  crash/restart loop re-emitting startup banners on every relaunch; `ThrottleInterval 10` bounds the
  restart rate, and we don't pass `--debug`. To debug, swap `--quiet` for `--debug` and
  `just kanata reload local.kanata`. A config-level middle ground exists if Info is ever wanted back
  without the spam: `log-layer-changes no` in `defcfg` silences just the layer dumps.
- **Rotation — deliberately NOT done, because the obvious way is worse than nothing.** launchd opens
  `StandardOutPath` once at spawn and the child inherits the fd; launchd never reopens it. So a
  rename-based rotator (newsyslog, the macOS default) leaves kanata writing to the renamed/unlinked
  inode while `/var/log/kanata.log` sits frozen and stale — a _misleading_ log, worse than an honest
  unbounded one. macOS newsyslog also can't run a command post-rotate (FreeBSD/OpenBSD can; Darwin's
  fork never gained it) and has no copytruncate, so it cannot even kick the daemon to reopen.
  Confirmed by an open apple-opensource/launchd bug report. `--quiet` makes growth slow enough that
  rotation is unnecessary for now; if it's ever needed, the paths forward (researched 2026-06-08;
  applies to any non-reopening daemon, so likely reused elsewhere) are, in order:
  - **copytruncate** (copy the live file aside, then truncate it _in place_) on a
    `StartCalendarInterval` launchd timer — via Homebrew `logrotate` with `copytruncate`, or a ~10-
    line script. The fd stays valid (same inode) so the log never freezes, the plist and the
    kill-switch/relaunch semantics are untouched, and no daemon restart is needed. It works because
    launchd opens std paths with `O_APPEND` (verified in launchd `src/core.c`:
    `O_WRONLY|O_CREAT|O_APPEND`), so a truncate-to-zero genuinely shrinks the file instead of
    leaving a growing sparse hole — `O_APPEND` is the prerequisite for _any_ copytruncate. Cost: a
    tiny lossy race at the truncate instant, negligible at this volume. **This is the recommended
    option if rotation is added.**
  - **Pipe through a file-owning rotator** (`rotatelogs`/`svlogd`/`multilog`) via a wrapper script.
    Most robust in the abstract, but launchd would then supervise the shell/pipeline, not kanata,
    muddying the `KeepAlive { SuccessfulExit = false }` exit-code gating that the kill switch
    depends on (needs `pipefail`/process-substitution care). Poor fit _here_ precisely because the
    exit code is load-bearing.
  - **Rename + create + scheduled `launchctl kickstart -k`** to force kanata to reopen. Works, but
    restarts the keyboard daemon on every rotation (a brief drop to the stock layout) — user-hostile
    for an input device.

  The Linux model that sidesteps all of this — daemon writes to stderr, journald owns capture, size
  caps, and rotation, so the daemon never touches a file — has no macOS equivalent (`os_log` needs
  the in-process API; an unset `StandardOutPath` just discards output). When kanata goes
  cross-platform under systemd, prefer that: no file, no rotation, `journalctl` to read.

The manual fallback still works if a daemon is uninstalled (`uninstall`) or for debugging — VHID
daemon first, then `sudo kanata --cfg ~/dotfiles/kanata/kanata.kbd` (the repo source, fine for a
one-off run) in a foreground terminal that doubles as a kill switch.

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
