#!/bin/bash -u
# See: ../_templates/README.md


_installed() {
    brew list python > /dev/null 2>&1; return $?
}

_config() {
    cp -fr .zsh.d "$HOME/"
}

version() {
    basename "$(readlink /usr/local/opt/python)"
}

install() {
    _installed || {
        depend install brew
        brew install python
    }
    _config
}

upgrade() {
    brew outdated python || {
        brew upgrade python
    }
}
