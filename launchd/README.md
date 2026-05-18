# launchd

`setenv-host.plist` sets the `HOST` environment variable to the short hostname at login so GUI
apps (which don't inherit shell env) can read it. Bombadil (macOS profile) symlinks it into
`~/Library/LaunchAgents/`; after that, activate it once:

```
launchctl load ~/Library/LaunchAgents/com.jonasmalaco.setenv.HOST.plist
```
