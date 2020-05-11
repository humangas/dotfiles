#!/bin/bash -u
# See: ../_templates/README.md


_installed() {
    brew list goenv > /dev/null 2>&1; return $?
}

_config() {
    cp -fr .zsh.d "$HOME/"
}

version() {
    basename "$(readlink /usr/local/opt/goenv)"
}

install() {
    _installed || {
        depend install brew
        brew install goenv
    }
    _config
}

upgrade() {
    brew outdated goenv || {
        brew upgrade goenv
    }
}
