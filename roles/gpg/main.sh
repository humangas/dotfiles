#!/usr/bin/env bash -eu
# See: ../_templates/README.md


_installed() {
    brew list gpg > /dev/null 2>&1; return $?
}

version() {
    basename "$(readlink /usr/local/opt/gpg)"
}

install() {
    _installed || {
        depend install brew
        depend install curl
        brew install gpg
    }
}

upgrade() {
    brew outdated gpg || {
        brew upgrade gpg
    }
}
