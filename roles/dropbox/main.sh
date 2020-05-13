#!/usr/bin/env bash -eu
# See: ../_templates/README.md


_installed() {
    brew cask list dropbox > /dev/null 2>&1; return $?
}

version() {
    ls /usr/local/Caskroom/dropbox 2>/dev/null
}

install() {
    _installed || {
        depend install brew
        brew cask install dropbox
    }
}

upgrade() {
    [[ -z $(brew cask outdated dropbox) ]] || {
        brew cask upgrade dropbox
    }
}
