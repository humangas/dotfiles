#!/bin/bash -u
# See: ../_templates/README.md


_installed() {
    brew list graphviz > /dev/null 2>&1; return $?
}

version() {
    basename "$(readlink /usr/local/opt/graphviz)"
}

install() {
    _installed || {
        depend install brew
        brew install graphviz
    }
}

upgrade() {
    brew outdated graphviz || {
        brew upgrade graphviz
    }
}
