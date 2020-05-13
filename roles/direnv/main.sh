#!/usr/bin/env bash -eu
# See: ../_templates/README.md


_installed() {
    brew list direnv > /dev/null 2>&1; return $?
}

_config() {
    cp -fr .zsh.d "$HOME/"
    cp -fr .config "$HOME/"
}

version() {
    basename "$(readlink /usr/local/opt/direnv)"
}

install() {
    _installed || {
        depend install brew
        depend install zsh
        brew install direnv
    }
    _config
}

upgrade() {
    brew outdated direnv || {
        brew upgrade direnv
    }
}
