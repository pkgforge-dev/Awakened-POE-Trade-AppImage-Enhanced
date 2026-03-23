#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(curl --retry 30 --retry-delay 2 --retry-all-errors -sL -o /dev/null -w %{url_effective} https://github.com/SnosMe/awakened-poe-trade/releases/latest | grep -oP '[^/]+$' | sed 's/^v//')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=awakened-poe-trade.png
export DESKTOP=awakened-poe-trade.desktop
export STARTUPWMCLASS="Awakened PoE Trade"
export DEPLOY_PULSE=1
export DEPLOY_OPENGL=1
export DEPLOY_VULKAN=1

# Deploy dependencies
quick-sharun ./AppDir/bin/* \
	         /usr/lib/libappindicator3.so*

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
