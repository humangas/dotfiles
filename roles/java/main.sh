#!/usr/bin/env bash -eu
# See: ../_templates/README.md


_installed() {
    brew cask list java > /dev/null 2>&1; return $?
}

version() {
    ls "/usr/local/Caskroom/java" 2>/dev/null
}

install() {
    _installed || {
        depend install brew
        brew cask install java
    }
}

upgrade() {
    [[ -z $(brew cask outdated java) ]] || {
        brew cask upgrade java
    }
}
