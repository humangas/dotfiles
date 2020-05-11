#!/bin/bash -u
# See: ../_templates/README.md


_installed() {
    brew cask list google-japanese-ime > /dev/null 2>&1; return $?
}

version() {
    ls /usr/local/Caskroom/google-japanese-ime 2>/dev/null
}

install() {
    _installed || {
        depend install brew
        brew cask install google-japanese-ime
    }
}

upgrade() {
    [[ -z $(brew cask outdated google-japanese-ime) ]] || {
        brew cask upgrade google-japanese-ime
    }
}
