#!/usr/bin/env bash -eu
# See: ../_templates/README.md


_installed() {
    brew list binutils > /dev/null 2>&1; return $?
}

version() {
    basename "$(readlink /usr/local/opt/binutils)"
}

install() {
    _installed || {
        depend install brew
        brew install binutils
    }
}

upgrade() {
    brew outdated binutils || {
        brew upgrade binutils
    }
}
