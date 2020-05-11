#!/bin/bash -u
# See: ../_templates/README.md


_installed() {
    brew list rbenv > /dev/null 2>&1; return $?
}

_is_installed_ruby-build() {
    type ruby-build > /dev/null 2>&1; return $?
}

_config() {
    cp -fr .zsh.d "$HOME/"
}

version() {
    basename "$(readlink /usr/local/opt/rbenv)"
}

install() {
    _installed || {
        depend install brew
        _is_installed_ruby-build || brew install ruby-build
        brew install rbenv
    }
    _config
}

upgrade() {
    brew outdated rbenv || {
        brew upgrade rbenv
    }
    _is_installed_ruby-build && {
        (brew outdated ruby-build || brew upgrade ruby-build)
    }
}
