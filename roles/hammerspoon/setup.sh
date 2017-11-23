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
    brew cask list "$SETUP_CURRENT_ROLE_NAME" > /dev/null 2>&1; return $?
}

version() {
    brew cask info "$SETUP_CURRENT_ROLE_NAME"
}

config() {
    mkdir -p ~/.hammerspoon/Spoons
    defaults write -app Terminal AppleLanguages "(en, ja)"
    cp "$SETUP_CURRENT_ROLE_DIR_PATH/init.lua" ~/.hammerspoon/
    log "INFO" "Install Hammerspoon/Calendar plugin..."
    curl -sL https://github.com/Hammerspoon/Spoons/raw/master/Spoons/Calendar.spoon.zip -# | tar xz -C ~/.hammerspoon/Spoons/
    log "INFO" "Install Hammerspoon/Caffeine plugin..."
    curl -sL https://github.com/Hammerspoon/Spoons/raw/master/Spoons/Caffeine.spoon.zip -# | tar xz -C ~/.hammerspoon/Spoons/
}

install() {
    depend "install" "brew"
    brew cask install "$SETUP_CURRENT_ROLE_NAME"
    config
    caveats "WARN" "- $SETUP_CURRENT_ROLE_NAME: Launch Hammerspoon > Enable Accessibility"
}

upgrade() {
    [[ -z $(brew cask outdated "$SETUP_CURRENT_ROLE_NAME") ]] || brew cask reinstall "$SETUP_CURRENT_ROLE_NAME"
}
