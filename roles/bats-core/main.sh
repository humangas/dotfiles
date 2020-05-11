#!/bin/bash -u
# See: ../_templates/README.md


_installed() {
    brew list bats-core > /dev/null 2>&1; return $?
}

version() {
    basename "$(readlink /usr/local/opt/bats-core)"
}

install() {
    _installed || {
        depend install brew
        brew install bats-core
    }
}

upgrade() {
    brew outdated bats-core || {
        brew upgrade bats-core
    }
}
