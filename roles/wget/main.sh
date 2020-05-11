#!/bin/bash -u
# See: ../_templates/README.md


_installed() {
    brew list wget > /dev/null 2>&1; return $?
}

version() {
    basename "$(readlink /usr/local/opt/wget)"
}

install() {
    _installed || {
        depend install brew
        brew install wget
    }
}

upgrade() {
    brew outdated wget || {
        brew upgrade wget
    }
}
