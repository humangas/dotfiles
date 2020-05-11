#!/usr/bin/env bash -eu
# See: ../_templates/README.md


_installed() {
    brew list watch > /dev/null 2>&1; return $?
}

version() {
    basename "$(readlink /usr/local/opt/watch)"
}

install() {
    _installed || {
        depend install brew
        brew install watch
    }
}

upgrade() {
    brew outdated watch || {
        brew upgrade watch
    }
}
