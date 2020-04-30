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

config() {
    # Dock position To bottom
    defaults write com.apple.dock orientation -string "bottom"
    # Automatically hide Dock 
    defaults write com.apple.dock autohide -bool true
    # Zoom icon when on mouse 
    defaults write com.apple.dock magnification -bool true
    # Dock icon zoom size
    defaults write com.apple.dock largesize -float 70
    # Dock icon size
    defaults write com.apple.dock tilesize -float 16
}

version() {
    echo "None"
}

install() {
    config
}

upgrade() {
    config
}
