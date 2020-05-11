#!/bin/bash -u
# See: ../_templates/README.md


_installed() {
    brew list xz > /dev/null 2>&1; return $?
}

version() {
    basename "$(readlink /usr/local/opt/xz)"
}

install() {
    _installed || {
        depend install brew
        brew install xz
    }
}

upgrade() {
    brew outdated xz || {
        brew upgrade xz
    }
}
