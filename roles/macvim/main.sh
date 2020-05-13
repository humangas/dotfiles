#!/usr/bin/env bash -eu
# See: ../_templates/README.md


_installed() {
    brew list macvim > /dev/null 2>&1; return $?
}

version() {
    ls /usr/local/Cellar/macvim 2>/dev/null
}

install() {
    _installed || {
        depend install brew
        depend install vim
        depend install python
        brew install macvim
    }
}

upgrade() {
    brew outdated macvim || {
        brew upgrade macvim
    }
}
