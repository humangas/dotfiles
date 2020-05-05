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

