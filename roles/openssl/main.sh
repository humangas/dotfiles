#!/usr/bin/env bash -eu
# See: ../_templates/README.md


_installed() {
    brew list openssl > /dev/null 2>&1; return $?
}

_config() {
    cp -fr .zsh.d "$HOME/"
}

version() {
    basename "$(readlink /usr/local/opt/openssl)"
}

install() {
    _installed || {
        depend install brew
        brew install openssl
    }
    _config
}

upgrade() {
    brew outdated openssl || {
        brew upgrade openssl
    }
}
