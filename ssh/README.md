# ssh

`config` sets `UseKeychain yes` so macOS stores SSH key passphrases in the system keychain and
`AddKeysToAgent yes` so the agent is populated on first use. The keychain entry is created once per
key with:

```
ssh-add --apple-use-keychain ~/.ssh/<keyfile>
```
