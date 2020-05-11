#!/bin/bash -u
# See: ../_templates/README.md


_installed() {
    brew list gnu-which > /dev/null 2>&1; return $?
}

_config() {
    cp -fr .zsh.d "$HOME/"
    for gnubin in /usr/local/opt/gnu-which/libexec/gnubin/*; do
        ln -fs $gnubin /usr/local/bin
    done
}

version() {
    basename "$(readlink /usr/local/opt/gnu-which)"
}

install() {
    _installed || {
        depend install brew
        brew install gnu-which
    }
    _config
}

upgrade() {
    brew outdated gnu-which || {
        brew upgrade gnu-which
    }
}
