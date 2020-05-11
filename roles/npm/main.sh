#!/bin/bash -u
# See: ../_templates/README.md


_installed() {
    brew list npm > /dev/null 2>&1; return $?
}

version() {
    basename "$(readlink /usr/local/opt/npm)"
}

install() {
    _installed || {
        depend install brew
        brew install npm
    }
}

upgrade() {
    brew outdated npm || {
        brew upgrade npm
    }
}
