#!/bin/bash -u
# See: ../_templates/README.md


_installed() {
    brew list jenv > /dev/null 2>&1; return $?
}

_config() {
    cp -fr .zsh.d "$HOME/"
}

version() {
    basename "$(readlink /usr/local/opt/jenv)"
}

install() {
    _installed || {
        depend install brew
        brew install jenv
    }
    _config
}

upgrade() {
    brew outdated jenv || {
        brew upgrade jenv
    }
}
