#!/bin/bash -u
# See: ../_templates/README.md


_installed() {
    brew list gawk > /dev/null 2>&1; return $?
}

_config() {
    cp -fr .zsh.d "$HOME/"
}

version() {
    basename "$(readlink /usr/local/opt/gawk)"
}

install() {
    _installed || {
        depend install brew
        brew install gawk
    }
    _config
}

upgrade() {
    brew outdated gawk || {
        brew upgrade gawk
    }
}
