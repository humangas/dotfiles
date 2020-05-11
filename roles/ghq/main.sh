#!/bin/bash -u
# See: ../_templates/README.md


_installed() {
    brew list ghq > /dev/null 2>&1; return $?
}

_config() {
    git config --global ghq.root "~/src"
}

version() {
    basename "$(readlink /usr/local/opt/ghq)"
}

install() {
    _installed || {
        depend install brew
        depend install git
        depend install go
        brew install ghq 
    }
    _config
}

upgrade() {
    brew outdated ghq || {
        brew upgrade ghq
    }
}
