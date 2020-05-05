#!/bin/bash -u
##############################################################################################
# Usage: source from roles/setup.sh
# Implementation of the following functions is required.
# - is_installed, version, config, install, upgrade, config
# The following functions can be used.
# - log, depend
# The following environment variables can be used.
# - SETUP_CURRENT_ROLE_NAME, SETUP_CURRENT_ROLE_DIR_PATH
##############################################################################################
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
