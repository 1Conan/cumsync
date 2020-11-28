#!/bin/bash

# linux
mkdir -p CumSync/node_modules/clipboardy/fallbacks/linux
nexe client/index.js -t linux-x64-12.9.1
mv cumsync CumSync/
cp client/scripts/start.sh CumSync/
chmod +x CumSync/start.sh
cp node_modules/clipboardy/fallbacks/linux/xsel CumSync/node_modules/clipboardy/fallbacks/linux

tar --numeric-owner --owner=1000 --group=1000 -c -z -f CumSync_linux.tgz CumSync
rm -rf CumSync

# macos
mkdir -p CumSync
nexe client/index.js -t macos-x64-12.9.1
mv cumsync CumSync/
cp client/scripts/start.sh CumSync/
chmod +x CumSync/start.sh

tar --numeric-owner --owner=501 --group=501 -c -z -f CumSync_macos.tgz CumSync
rm -rf CumSync

# winblows
mkdir -p CumSync/node_modules/clipboardy/fallbacks/windows
nexe client/index.js -t windows-x64-12.9.1
mv cumsync.exe CumSync/
cp client/scripts/start.bat CumSync/
cp node_modules/clipboardy/fallbacks/windows/clipboard_x86_64.exe CumSync/node_modules/clipboardy/fallbacks/windows

zip -r -X CumSync_windows.zip CumSync
rm -rf CumSync
