#!/usr/bin/env bash -eu
# See: ../_templates/README.md


_installed() {
    brew cask list skitch > /dev/null 2>&1; return $?
}

version() {
    ls /usr/local/Caskroom/skitch 2>/dev/null
}

install() {
    _installed || {
        depend install brew
        brew cask install skitch
    }
}

upgrade() {
    [[ -z $(brew cask outdated skitch) ]] || {
        brew cask upgrade skitch
    }
}
