#!/bin/bash -u
# See: ../_templates/README.md


_installed() {
    brew list curl > /dev/null 2>&1; return $?
}

_config() {
    cp -fr .zsh.d "$HOME/"
}

version() {
    basename "$(readlink /usr/local/opt/curl)"
}

install() {
    _installed || {
        depend install brew
        brew install curl
    }
    _config
}

upgrade() {
    brew outdated curl || {
        brew upgrade curl
    }
}
