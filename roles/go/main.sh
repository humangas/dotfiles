#!/usr/bin/env bash -eu
# See: ../_templates/README.md


_installed() {
    brew list go > /dev/null 2>&1; return $?
}

_config() {
    mkdir -p $HOME/src
    mkdir -p $HOME/bin
    mkdir -p $HOME/pkg
    cp -fr .zsh.d "$HOME/"
}

version() {
    basename "$(readlink /usr/local/opt/go)"
}

install() {
    _installed || {
        depend install brew
        brew install go
    }
    _config
}

upgrade() {
    brew outdated go || {
        brew upgrade go
    }
}
