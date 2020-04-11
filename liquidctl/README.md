Automatic liquidctl configuration
=================================

 - [Static configuration after boot](#static-configuration-after-boot)
 - [Dynamic adjustment of lights throughout the day](#dynamic-adjustment-of-lights-throughout-the-day)

Static configuration after boot
-------------------------------

For day to day usage is it desirable to have the system automatically run
liquidctl and configure each device by itself.

The first step is to create a script with all necessary calls to liquidctl.  It
can be written in any language, but for simplicity I stick with a simple Bash
script: [`liquidcfg`](./liquidcfg).

The system then has to configured to automatically start that script; most
likely, you will want it to run at every boot.

How to do this will depend on the OS (and maybe distribution) you use.
Personally, I run Arch Linux and, these days, Systemd is ubiquitous on most
Linux distributions.  I will assume you are running Systemd as well, but if
this is not the case, check your distribution's documentation for how to
configure programs to start at every boot.

With Systemd, the most straightforward setup is to add a new system
[service](https://www.freedesktop.org/software/systemd/man/systemd.service.html).
For my Bash script, a `Type=simple` service is sufficient:
[`liquidcfg.service`](./liquidcfg.service).  This file is also called a _unit_
file.

While communication with USB devices is usually restricted to users with root
privileges, this is not an issue here because, by default, system services
already run as the root user.

Unit files for system services should be installed inside
`/etc/systemd/system`.  It is also necessary to run `systemctl
daemon-reload` every time a change is been made to them.

The configuration script itself has fewer restrictions, and I like to have it
inside `/usr/local/bin`.  I also use a simple [`Makefile`](./Makefile) to
automate my installation procedure.

Once you have created and installed your own script and service files, you can
test them by starting the service.

```
# systemctl start liquidcfg
```

You can then use liquidctl, systemctl and journalctl to check if everything
is working as it should.

```
# systemctl status liquidcfg -n 99
# journalctl -u liquidcfg
# liquidctl status
```

If necessary, you can also start the script manually, which will be easier to
debug.

Finally, once you are happy with the results, enable the service to have it start
automatically.

```
# systemctl enable liquidcfg
```

Dynamic adjustment of lights throughout the day
-----------------------------------------------

This folder also includes `liquiddyncfg` (and associated service and timer
files), which I use to dynamically configuration my cooler and case lights
throughout the day.

This is similar to the boot-time setup, except that a timer is used to have it
run at period intervals.

For more information see:
[Trick: changing cooler and case lighting according to time of day (Linux&macOS)](https://www.reddit.com/r/NZXT/comments/fz3o4t/trick_changing_cooler_and_case_lighting_according/)
gn r/NZXT.
