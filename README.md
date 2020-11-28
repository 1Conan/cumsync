# CumSync

An open source clipboard sync for linux/windows/mac + ios devices.
Really barebones. Maybe package the client with a UI using electron. Honestly idrc.

Tested on iOS 7,12,13 (Could work on iOS 3 and above?)

Blame Jimmehh

## Requirements

- node.js

## PC Client Installation

```bash
cd client
npm i
```

## Server configuration

```bash
#!/bin/bash
export DEVICE_IP=10.0.13.17
export SSH_USERNAME=mobile
export SSH_PASSWORD=alpine # change this retard
export SSH_PRIVATEKEY=/home/conan/.ssh/id_retard
export SSH_PRIVATEKEY_PASSPHRASE=imaretard

node client
```
