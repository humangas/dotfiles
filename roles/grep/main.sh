#!/usr/bin/env bash -eu
# See: ../_templates/README.md


_installed() {
    brew list grep > /dev/null 2>&1; return $?
}

_config() {
    cp -fr .zsh.d "$HOME/"
    for gnubin in /usr/local/opt/grep/libexec/gnubin/*; do
        ln -fs $gnubin /usr/local/bin
    done
}

version() {
    basename "$(readlink /usr/local/opt/grep)"
}

install() {
    _installed || {
        depend install brew
        brew install grep
    }
    _config
}

upgrade() {
    brew outdated grep || {
        brew upgrade grep
    }
}
