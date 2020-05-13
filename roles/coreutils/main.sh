#!/usr/bin/env bash -eu
# See: ../_templates/README.md


_installed() {
    brew list coreutils > /dev/null 2>&1; return $?
}

_config() {
    cp -fr .zsh.d "$HOME/"
    for gnubin in /usr/local/opt/coreutils/libexec/gnubin/*; do
        ln -fs $gnubin /usr/local/bin
    done
}

version() {
    basename "$(readlink /usr/local/opt/coreutils)"
}

install() {
    _installed || {
        depend install brew
        depend install xz
        brew install coreutils
    }
    _config
}

upgrade() {
    brew outdated coreutils || {
        brew upgrade coreutils
    }
}
