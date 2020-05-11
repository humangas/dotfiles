#!/bin/bash -u
# See: ../_templates/README.md


_installed() {
    brew list fzf > /dev/null 2>&1; return $?
}

_config() {
    cp -fr .zsh.d "$HOME/"
}

version() {
    basename "$(readlink /usr/local/opt/fzf)"
}

install() {
    _installed || {
        depend install brew
        brew install fzf
        /usr/local/opt/fzf/install --key-bindings --completion --no-update-rc
    }
    _config
}

upgrade() {
    brew outdated fzf || {
        brew upgrade fzf
    }
}
