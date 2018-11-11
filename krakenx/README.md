Automatic krakenx configuration at boot
=========================================

This is just an example of how to use Systemd to have the system automatically
run krakenx and configure a Kraken cooler by itself.

The most straightforward setup is to add a new system
[service](https://www.freedesktop.org/software/systemd/man/systemd.service.html).
A `Type=simple` service is sufficient:
[`krakenx-config.service`](./krakenx-config.service).  This file is also called
a _unit_ file.

While communication with USB devices is usually restricted to users with root
privileges, this is not an issue here because, by default, system services
already run as the root user.

Unit files for system services should be installed inside
`/etc/systemd/system`.  It is also necessary to run `systemctl daemon-reload`
every time a change is been made to them.  I also added a simple
[`Makefile`](./Makefile) to automate the installation.  procedure.

Once you have created and installed your own service file, you can test it by
starting the service.

```
# systemctl start liquidcfg
```

You can then use krakenx, systemctl and journalctl to check if everything
is working as it should.

```
# systemctl status krakenx-config -n 99
# journalctl -u krakenx-config
# colctl -s
```

Finally, once you are happy with the results, enable the service to have it start
automatically.

```
# systemctl enable krakenx-config
```

