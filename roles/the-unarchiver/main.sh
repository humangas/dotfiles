#!/bin/bash -u
# See: ../_templates/README.md


_installed() {
    brew cask list the-unarchiver > /dev/null 2>&1; return $?
}

version() {
    ls /usr/local/Caskroom/the-unarchiver 2>/dev/null
}

install() {
    _installed || {
        depend install brew
        brew cask install the-unarchiver
    }
}

upgrade() {
    [[ -z $(brew cask outdated the-unarchiver) ]] || {
        brew cask reinstall the-unarchiver
    }
}
