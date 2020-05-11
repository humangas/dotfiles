#!/usr/bin/env bash -eu
# See: ../_templates/README.md


_installed() {
    brew list gzip > /dev/null 2>&1; return $?
}

version() {
    basename "$(readlink /usr/local/opt/gzip)"
}

install() {
    _installed || {
        depend install brew
        brew install gzip
    }
}

upgrade() {
    brew outdated gzip || {
        brew upgrade gzip
    }
}
