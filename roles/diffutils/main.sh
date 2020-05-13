#!/usr/bin/env bash -eu
# See: ../_templates/README.md


_installed() {
    brew list diffutils > /dev/null 2>&1; return $?
}

version() {
    basename "$(readlink /usr/local/opt/diffutils)"
}

install() {
    _installed || {
        depend install brew
        brew install diffutils
    }
}

upgrade() {
    brew outdated diffutils || {
        brew upgrade diffutils
    }
}
