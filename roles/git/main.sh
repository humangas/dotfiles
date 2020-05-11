#!/bin/bash -u
# See: ../_templates/README.md


_installed() {
    brew list git > /dev/null 2>&1; return $?
}

_config() {
    git config --global user.name "humangas"
    git config --global user.email "humangas.net@gmail.com"
    curl -sL https://raw.githubusercontent.com/github/gitignore/master/Global/macOS.gitignore > ~/.gitignore_global
    git config --global core.excludesfile ~/.gitignore_global
}

version() {
    basename "$(readlink /usr/local/opt/git)"
}

install() {
    _installed || {
        depend install brew
        brew install git
    }
    _config
}

upgrade() {
    brew outdated git || {
        brew upgrade git
    }
}
