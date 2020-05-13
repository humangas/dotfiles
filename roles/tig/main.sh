#!/usr/bin/env bash -eu
# See: ../_templates/README.md


_installed() {
    brew list tig > /dev/null 2>&1; return $?
}

_config() {
    cp .tigrc "$HOME/"
}

version() {
    basename "$(readlink /usr/local/opt/tig)"
}

install() {
    _installed || {
        depend install brew
        depend install git
        brew install tig
    }
    _config
}

upgrade() {
    brew outdated tig || {
        brew upgrade tig
    }
}
