#!/usr/bin/env bash -eu
# See: ../_templates/README.md


_installed() {
    brew list gnu-sed > /dev/null 2>&1; return $?
}

_config() {
    cp -fr .zsh.d "$HOME/"
    for gnubin in /usr/local/opt/gnu-sed/libexec/gnubin/*; do
        ln -fs $gnubin /usr/local/bin
    done
}

version() {
    basename "$(readlink /usr/local/opt/gnu-sed)"
}

install() {
    _installed || {
        depend install brew
        brew install gnu-sed
    }
    _config
}

upgrade() {
    brew outdated gnu-sed || {
        brew upgrade gnu-sed
    }
}
