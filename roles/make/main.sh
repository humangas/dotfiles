#!/usr/bin/env bash -eu
# See: ../_templates/README.md


_installed() {
    brew list make > /dev/null 2>&1; return $?
}

_config() {
    cp -fr .zsh.d "$HOME/"
    for gnubin in /usr/local/opt/make/libexec/gnubin/*; do
        ln -fs $gnubin /usr/local/bin
    done
}

version() {
    basename "$(readlink /usr/local/opt/make)"
}

install() {
    _installed || {
        depend install brew
        brew install make
    }
    _config
}

upgrade() {
    brew outdated make || {
        brew upgrade make
    }
}
