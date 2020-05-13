#!/usr/bin/env bash -eu
# See: ../_templates/README.md


_installed() {
    brew list pyenv > /dev/null 2>&1; return $?
}

_config() {
    cp -fr .zsh.d "$HOME/"
}

version() {
    basename "$(readlink /usr/local/opt/pyenv)"
}

install() {
    _installed || {
        depend install brew
        brew install pyenv
        brew install pyenv-virtualenv
    }
    _config
}

upgrade() {
    brew outdated pyenv || {
        brew upgrade pyenv
    }
    brew outdated pyenv-virtualenv || {
        brew upgrade pyenv-virtualenv
    }
}
