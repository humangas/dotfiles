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
    brew cask list hammerspoon > /dev/null 2>&1; return $?
}

_config() {
    mkdir -p ~/.hammerspoon/Spoons
    defaults write -app Terminal AppleLanguages "(en, ja)"
    cp -fr .hammerspoon "$HOME/"
    log "INFO" "Install Hammerspoon plugin: Calendar..."
    curl -sL https://github.com/Hammerspoon/Spoons/raw/master/Spoons/Calendar.spoon.zip -# | /usr/bin/tar xz -C ~/.hammerspoon/Spoons/
    log "INFO" "Install Hammerspoon plugin: Caffeine..."
    curl -sL https://github.com/Hammerspoon/Spoons/raw/master/Spoons/Caffeine.spoon.zip -# | /usr/bin/tar xz -C ~/.hammerspoon/Spoons/
}

version() {
    ls /usr/local/Caskroom/hammerspoon 2>/dev/null
}

install() {
    _installed || {
        depend install brew
        brew cask install hammerspoon 
    }
    _config
    caveats "WARN" "- hammerspoon: Manual Operation -> Launch Hammerspoon > Enable Accessibility"
}

upgrade() {
    [[ -z $(brew cask outdated "$SETUP_CURRENT_ROLE_NAME") ]] || brew cask reinstall "$SETUP_CURRENT_ROLE_NAME"
}
