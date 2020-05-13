#!/usr/bin/env bash -eu
# See: ../_templates/README.md


_installed() {
    brew list gnu-indent > /dev/null 2>&1; return $?
}

_config() {
    cp -fr .zsh.d "$HOME/"
    for gnubin in /usr/local/opt/gnu-indent/libexec/gnubin/*; do
        ln -fs $gnubin /usr/local/bin
    done
}

version() {
    basename "$(readlink /usr/local/opt/gnu-indent)"
}

install() {
    _installed || {
        depend install brew
        brew install gnu-indent
    }
    _config
}

upgrade() {
    brew outdated gnu-indent || {
        brew upgrade gnu-indent
    }
}
