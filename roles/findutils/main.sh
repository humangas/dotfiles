#!/usr/bin/env bash -eu
# See: ../_templates/README.md


_installed() {
    brew list findutils > /dev/null 2>&1; return $?
}

_config() {
    cp -fr .zsh.d "$HOME/"
    for gnubin in /usr/local/opt/findutils/libexec/gnubin/*; do
        ln -fs $gnubin /usr/local/bin
    done
}

version() {
    basename "$(readlink /usr/local/opt/findutils)"
}

install() {
    _installed || {
        depend install brew
        brew install findutils
    }
    _config
}

upgrade() {
    brew outdated findutils || {
        brew upgrade findutils
    }
}
