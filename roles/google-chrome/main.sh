#!/usr/bin/env bash -eu
# See: ../_templates/README.md


_installed() {
    brew cask list google-chrome > /dev/null 2>&1; return $?
}

version() {
    ls /usr/local/Caskroom/google-chrome 2>/dev/null
}

install() {
    _installed || {
        depend install brew
        brew cask install google-chrome
    }
}

upgrade() {
    [[ -z $(brew cask outdated google-chrome) ]] || {
        brew cask upgrade google-chrome 
    }
}
