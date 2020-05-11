#!/bin/bash -u
# See: ../_templates/README.md


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
    log "WARN" "- hammerspoon: Manual Operation -> Launch Hammerspoon > Enable Accessibility"
}

upgrade() {
    [[ -z $(brew cask outdated hammerspoon) ]] || {
        brew cask upgrade hammerspoon
    }
}
