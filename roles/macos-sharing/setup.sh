#!/bin/bash -u
##############################################################################################
# Usage: source from roles/setup.sh
# Implementation of the following functions is required.
# - is_installed, version, config, install, upgrade, config
# The following functions can be used.
# - log, depend
# The following environment variables can be used.
# - SETUP_CURRENT_ROLE_NAME, SETUP_CURRENT_ROLE_DIR_PATH
##############################################################################################
is_installed() {
    [[ "$SETUP_FUNC_NAME" == "install" ]] && return 1
    return 0
}

version() {
    echo "-"
}

config() {
    # $ xxd -r -p <<< 68756d616e676173
    # humangas
    sudo -v; while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    SETUP_COMPUTER_NAME="68756d616e676173"
    sudo scutil --set ComputerName "$SETUP_COMPUTER_NAME"
    sudo scutil --set HostName "$SETUP_COMPUTER_NAME"
    sudo scutil --set LocalHostName "$SETUP_COMPUTER_NAME"
    sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$SETUP_COMPUTER_NAME"
}

install() {
    config
}

upgrade() {
    config
}