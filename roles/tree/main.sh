#!/usr/bin/env bash -eu
# See: ../_templates/README.md


_installed() {
    brew list tree > /dev/null 2>&1; return $?
}

version() {
    basename "$(readlink /usr/local/opt/tree)"
}

install() {
    _installed || {
        depend install brew
        brew install tree
    }
}

upgrade() {
    brew outdated tree || {
        brew upgrade tree
    }
}
