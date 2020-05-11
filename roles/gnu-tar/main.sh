#!/bin/bash -u
# See: ../_templates/README.md


_installed() {
    brew list gnu-tar > /dev/null 2>&1; return $?
}

_config() {
    cp -fr .zsh.d "$HOME/"
    for gnubin in /usr/local/opt/gnu-tar/libexec/gnubin/*; do
        ln -fs $gnubin /usr/local/bin
    done
}

version() {
    basename "$(readlink /usr/local/opt/gnu-tar)"
}

install() {
    _installed || {
        depend install brew
        brew install gnu-tar
    }
    _config
}

upgrade() {
    brew outdated gnu-tar || {
        brew upgrade gnu-tar
    }
}
