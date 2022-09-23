It's useful to create `~/.ssh/config` similar to this:

```
Host bastion-host
    HostName localhost
    Port 2222
    User dev
    ForwardAgent yes
    ForwardX11 yes
    IdentityFile ~/.ssh/id_ed25519
    UserKnownHostsFile /dev/null
    StrictHostKeyChecking no
    NoHostAuthenticationForLocalhost yes

Host *.default
    Port 2222
    User root
    ForwardAgent yes
    ForwardX11 yes
    RequestTTY force
    UserKnownHostsFile /dev/null
    IdentityFile ~/.ssh/id_ed25519
    StrictHostKeyChecking no
    NoHostAuthenticationForLocalhost yes
    ProxyJump bastion-host
```