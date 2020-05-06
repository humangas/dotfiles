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
    brew list go > /dev/null 2>&1; return $?
}

_config() {
    mkdir -p $HOME/src
    mkdir -p $HOME/bin
    mkdir -p $HOME/pkg
    cp -fr .zsh.d "$HOME/"
}

version() {
    basename "$(readlink /usr/local/opt/go)"
}

install() {
    _installed || {
        depend install brew
        brew install go
    }
    _config
}

upgrade() {
    brew outdated go || {
        brew upgrade go
    }
}
