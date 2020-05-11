#!/bin/bash -u
# See: ../_templates/README.md


_installed() {
    brew list gnu-getopt > /dev/null 2>&1; return $?
}

_config() {
    cp -fr .zsh.d "$HOME/"
}

version() {
    basename "$(readlink /usr/local/opt/gnu-getopt)"
}

install() {
    _installed || {
        depend install brew
        brew install gnu-getopt
    }
    _config
}

upgrade() {
    brew outdated gnu-getopt || {
        brew upgrade gnu-getopt
    }
}
