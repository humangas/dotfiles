#!/bin/bash -u
# See: ../_templates/README.md


_installed() {
    brew list nodenv > /dev/null 2>&1; return $?
}

_is_installed_node-build() {
    type node-build > /dev/null 2>&1; return $?
}

_config() {
    cp -fr .zsh.d "$HOME/"
}

version() {
    basename "$(readlink /usr/local/opt/nodenv)"
}

install() {
    _installed || {
        depend install brew
        _is_installed_node-build || brew install node-build
        brew install nodenv
    }
    _config
}

upgrade() {
    brew outdated nodenv || {
        brew upgrade nodenv
    }
    _is_installed_node-build && {
        (brew outdated node-build || brew upgrade node-build)
    }
}
