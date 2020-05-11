#!/bin/bash -u
# See: ../_templates/README.md


_installed() {
    brew list lua > /dev/null 2>&1; return $?
}

version() {
    basename "$(readlink /usr/local/opt/lua)"
}

install() {
    _installed || {
        depend install brew
        brew install lua
    }
}

upgrade() {
    brew outdated lua || {
        brew upgrade lua
    }
}
