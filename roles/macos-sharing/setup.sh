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
_installed() {
    [[ "$SETUP_FUNC_NAME" == "install" ]] && return 1
    return 0
}

_config() {
    # $ xxd -p <<< humangas
    # 68756d616e6761730a
    # $ xxd -r -p <<< 68756d616e6761730a
    # humangas
    SETUP_COMPUTER_NAME="${SETUP_COMPUTER_NAME:-68756d616e6761730a}"
    sudo scutil --set ComputerName "$SETUP_COMPUTER_NAME"
    sudo scutil --set HostName "$SETUP_COMPUTER_NAME"
    sudo scutil --set LocalHostName "$SETUP_COMPUTER_NAME"
    sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$SETUP_COMPUTER_NAME"
}

version() {
    echo "None"
}

install() {
    _config
}

upgrade() {
    _config
}
