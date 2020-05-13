#!/usr/bin/env bash -eu
# See: ../_templates/README.md


_installed() {
    brew list hub > /dev/null 2>&1; return $?
}

_config() {
    cp -fr .zsh.d "$HOME/"
}

version() {
    basename "$(readlink /usr/local/opt/hub)"
}

install() {
    _installed || {
        depend install brew
        brew install hub
    }
    _config
}

upgrade() {
    brew outdated hub || {
        brew upgrade hub
    }
}
