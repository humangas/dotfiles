#!/usr/bin/env bash -eu
# See: ../_templates/README.md


_installed() {
    brew list ed > /dev/null 2>&1; return $?
}

_config() {
    cp -fr .zsh.d "$HOME/"
    for gnubin in /usr/local/opt/ed/libexec/gnubin/*; do
        ln -fs $gnubin /usr/local/bin
    done
}

version() {
    basename "$(readlink /usr/local/opt/ed)"
}

install() {
    _installed || {
        depend install brew
        brew install ed
    }
    _config
}

upgrade() {
    brew outdated ed || {
        brew upgrade ed
    }
}
