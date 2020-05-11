#!/bin/bash -u
# See: ../_templates/README.md


_installed() {
    brew cask list clipy > /dev/null 2>&1; return $?
}

version() {
    ls /usr/local/Caskroom/clipy 2>/dev/null
}

install() {
    _installed || {
        depend install brew
        brew cask install clipy
    }
}

upgrade() {
    [[ -z $(brew cask outdated clipy) ]] || {
        brew cask upgrade clipy
    }
}
