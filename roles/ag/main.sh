#!/usr/bin/env bash -eu
# See: ../_templates/README.md


_installed() {
    brew list ag > /dev/null 2>&1; return $?
}

_config() {
    cp -fr .zsh.d "$HOME/"
    cp -f .agignore "$HOME/"
}

version() {
    basename "$(readlink /usr/local/opt/ag)"
}

install() {
    _installed || {
        depend install brew
        brew install ag 
    }
    _config
}

upgrade() {
    brew outdated ag || {
        brew upgrade ag
    }
}

