# Autostart kanata on macOS with launchd LaunchDaemons

Source copies of three LaunchDaemon property lists that autostart the Karabiner driver activation,
its VHID daemon, and kanata at boot, replacing the manual two-step in the main `CLAUDE.md`
("Operational Setup").

**Nothing here is automatically installed.** Installing it is the manual, sudo-gated procedure
below, to run only after the config is trusted. Until then the manual foreground-terminal method
still works and doubles as a kill-switch fallback.

All three run as **root** (kanata needs to grab the keyboard; the Karabiner pieces ship as
`root:wheel`), so they are LaunchDaemons in `/Library/LaunchDaemons/`, not per-user LaunchAgents.
That directory is root-owned and outside `$HOME`, so it can't be symlinked from the repo — the
plists are kept here as source and copied out by hand.

## Files

- `local.karabiner-vhid-manager.plist` — runs the Karabiner Manager's `activate` once at boot to
  (re)register the DriverKit system extension. One-shot (`RunAtLoad`, no `KeepAlive`): it submits
  the activation request and exits. Cheap insurance that re-stages the dext after a macOS or
  Karabiner update (the usual "driver_version mismatched" cause); the OS reloads an already-approved
  extension on its own regardless. First-time approval is a manual GUI step, already done on turing.
- `local.karabiner-vhid-daemon.plist` — the Karabiner DriverKit VirtualHIDDevice daemon.
  Prerequisite: it must be up before kanata can open the virtual keyboard.
- `local.kanata.plist` — kanata, reading `/Library/Application Support/kanata/kanata.kbd`, a
  root-owned copy of the repo config staged by `just kanata sync-config` (see "Config file" below).
  kanata runs as root, so a user-writable `--cfg` would be a root-escalation path.

Load order is manager -> daemon -> kanata (the `install`/`uninstall` recipes handle it). launchd
doesn't enforce ordering, and it isn't essential here: kanata retries the VHID connection on its own
and `KeepAlive` relaunches it, so it tolerates starting before the other two are ready.

## Config file (root-owned)

kanata runs as root, so the config it loads must not be writable by the login user. A user-writable
`--cfg` would let any process running as `jonas` rewrite what a root process executes — a privilege
escalation, sharpest if the build allows `cmd` (it doesn't: Homebrew's kanata is "compiled to never
allow cmd", so `danger-enable-cmd` is inert here; but a root process driving the keyboard is reason
enough on its own).

So the daemon reads a root-owned copy at `/Library/Application Support/kanata/kanata.kbd`
(`root:wheel`, `0644`), staged from the repo source (`../kanata.kbd`) by `just kanata sync-config`,
exactly as the plists are copied into `/Library/LaunchDaemons`. Edit the source in the repo and
validate it offline with `just kanata check-config` (`kanata --check`); the repo file is no longer
what the daemon loads.

The cost is the edit loop: an edit reaches the daemon only after it is re-staged.

```sh
# edit kanata/kanata.kbd in the repo, then:
just kanata sync-config   # --check, copy to the root-owned path, restart kanata
```

`sync-config` restarts kanata (a brief drop to the default layout), so the reload is deterministic
and `--check`-gated. esc+F5 still triggers kanata's own live reload, but it rereads the root-owned
copy, so it only reflects an edit once `sync-config` has staged it.

> [!NOTE]
>
> This is the macOS half. On Linux the plan is to run kanata as a dedicated, less-privileged
> `kanata` user (not `jonas`), with the config likewise root-owned and only readable by that user —
> same principle, staged into a Linux path when that setup lands.

## Relaunch policy (the two `KeepAlive`s differ on purpose)

- **Karabiner daemon: plain `KeepAlive` (always relaunch).** It is pure infrastructure with no
  intentional-exit story. If it dies while kanata is still running, kanata's output sink vanishes
  and keystrokes get swallowed — worse than the default layout — so it should be up unconditionally.
- **kanata: `KeepAlive { SuccessfulExit = false }` (relaunch only on a non-zero exit).** launchd's
  equivalent of systemd `Restart=on-failure`. This threads the needle between the two failure modes:
  - **Kill switch stays a kill switch.** Since 1.11.0 the panic combo (LCtrl+Space+Esc) exits 0 by
    default (`--emergency-exit-code`, fixing [#1902](https://github.com/jtroo/kanata/issues/1902)).
    A clean exit is _not_ relaunched, so hitting it really drops you to the stock macOS layout to
    fall back and diagnose — exactly the escape hatch worth keeping. (Earlier kanata _panicked_
    here, a non-zero exit a service manager would instantly restart; that was the bug.)
  - **Crashes self-heal.** macOS sleep/wake can still crash kanata
    ([#1357](https://github.com/jtroo/kanata/issues/1357), open on 1.11.0; a separate wake crash
    [#2008](https://github.com/jtroo/kanata/issues/2008) was fixed in 1.12.0-prerelease-2). A crash
    is a non-zero exit, so it _is_ relaunched and the keyboard comes back on its own after waking —
    which is the main reason auto-relaunch earns its keep on macOS. `ThrottleInterval 10` bounds a
    crash loop (or a config that won't load at boot) to one attempt per 10s, visible in the log.

If you'd rather kanata never auto-restart (fully manual recovery), drop kanata's `KeepAlive`
entirely — but then a sleep/wake crash leaves you on the default layout until you reload the service
by hand.

## Permissions (TCC) — manual, cannot be scripted

This is the part that changes when moving off the terminal. When kanata ran under `sudo` from a
terminal, it had no TCC identity of its own, so macOS attributed its events to the launching app
(kitty). As a LaunchDaemon, **kanata is its own responsible process**, so the rights must be granted
to the kanata binary itself, at `/opt/homebrew/bin/kanata`:

- **Input Monitoring** — required for kanata to read the physical keyboard at all. Without it kanata
  loads but captures nothing.
- **Accessibility** — required only for the `(unicode)` accent codepath (it posts synthetic events
  via `CGEventPost`; see the unicode note in `CLAUDE.md`). Without it every other remap still works
  and only the direct-unicode accents fail.

> [!TIP]
>
> To reach `/opt/homebrew/` either show hidden files with ⌘⇧. or Go to Folder with ⌘⇧G.

A background daemon can't raise the GUI permission prompt, so both must be added by hand in **System
Settings > Privacy & Security**, under each list: click `+`, then in the file picker press
`Cmd+Shift+G` and enter `/opt/homebrew/bin/kanata`. A logout/reboot may be needed for the grant to
take. (The earlier kitty grant for Accessibility becomes irrelevant once kanata runs as the daemon.)

Two reported quirks worth knowing in advance:

- **Input Monitoring sometimes won't "take".** If kanata loads but captures nothing (look for
  `IOHIDDeviceOpen error: ... not permitted` in the log), the standard fix is to **remove** kanata
  from the Input Monitoring list and **re-add** it, then reboot.
- **A `brew upgrade` of kanata can void the grant.** TCC keys on the resolved binary, and Homebrew
  installs each version under a new `Cellar/kanata/<version>/` path (the `/opt/homebrew/bin/kanata`
  symlink is just a pointer). After an upgrade you may need to re-grant Input Monitoring.

## Install and manage (justfile)

The sudo-gated steps live in `justfile` here. The root `justfile` imports them via
`mod kanata 'kanata/launchd'`, so run them as `just kanata <recipe>` from the repo root (or
`just <recipe>` from this directory). Each `install`/`uninstall`/`reload` recipe touches
`/Library/LaunchDaemons` and the system launchd domain, so it prompts for a sudo password.

```sh
just kanata lint          # validate plist syntax — no sudo, no system changes
just kanata check-config  # validate kanata.kbd offline (kanata --check) — no sudo
just kanata install       # copy plists + config out, chown root:wheel + chmod, bootstrap in order
just kanata sync-config   # re-stage the config and restart kanata after editing kanata.kbd
just kanata status        # show whether each job is loaded and running
just kanata logs          # tail /var/log/kanata.log
just kanata uninstall     # bootout all three, remove the plists and the staged config
just kanata reload local.kanata   # re-read one plist after editing it
```

`install` runs `lint` and `check-config` first, then copies (launchd refuses to load a plist that
isn't root-owned and non-writable by group/other) and stages the config to its root-owned path
before bootstrapping kanata. `RunAtLoad` starts all immediately, and at every boot thereafter.

The kill switch (Left Control + Space + Escape) still terminates kanata, and per the relaunch policy
above it stays down (clean exit 0), dropping you to the default layout; relaunch it with
`just kanata reload local.kanata` or `sudo launchctl kickstart system/local.kanata`.

Editing `kanata.kbd` now needs `just kanata sync-config` to reach the daemon (it reads the
root-owned copy, not the repo symlink — see "Config file" above). esc + F5 still triggers kanata's
live reload, but it rereads that root-owned copy, so it only picks up an edit after `sync-config`
has staged it. Editing a _plist_ needs `just kanata reload <label>` (a bootstrapped plist is not
re-read live).

## Useful links

- [Instructions for macOS](https://github.com/jtroo/kanata/blob/45be1c2fe15b/docs/setup-macos.md)
- [Instructions for Linux](https://github.com/jtroo/kanata/blob/45be1c2fe15b/docs/setup-linux.md)
- [Known issues on macOS](https://github.com/jtroo/kanata/blob/45be1c2fe15b/docs/platform-known-issues.adoc#macos)
- [sample kanata.plist](https://github.com/jtroo/kanata/blob/45be1c2fe15b/cfg_samples/kanata.plist)
- [sample karabiner-vhid-daemon.plist](https://github.com/jtroo/kanata/blob/45be1c2fe15b/cfg_samples/karabiner-vhid-daemon.plist)
- [How to use Kanata from Homebrew and LaunchCtl for macOS (#1537)](https://github.com/jtroo/kanata/discussions/1537)
