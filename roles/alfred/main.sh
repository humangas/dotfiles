#!/usr/bin/env bash -eu
# See: ../_templates/README.md


_installed() {
    brew cask list alfred > /dev/null 2>&1; return $?
}

version() {
    ls /usr/local/Caskroom/alfred 2>/dev/null
}

install() {
    _installed || {
        depend install brew
        brew cask install alfred
    }
}

upgrade() {
    [[ -z $(brew cask outdated alfred) ]] || {
        brew cask reinstall alfred
    }
}
