#!/bin/bash -u
# See: ../_templates/README.md


_installed() {
    brew cask list docker > /dev/null 2>&1; return $?
}

version() {
    ls /usr/local/Caskroom/docker 2>/dev/null
}

install() {
    _installed || {
        depend install brew
        brew cask install docker
    }
}

upgrade() {
    [[ -z $(brew cask outdated docker) ]] || {
        brew cask reinstall docker
    }
}
