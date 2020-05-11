#!/bin/bash -u
# See: ../_templates/README.md


_installed() {
    brew list bash > /dev/null 2>&1; return $?
}

version() {
    basename "$(readlink /usr/local/opt/bash)"
}

install() {
    _installed || {
        depend install brew
        brew install bash
    }
}

upgrade() {
    brew outdated bash || {
        brew upgrade bash
    }
}
