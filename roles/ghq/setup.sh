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
    brew list ghq > /dev/null 2>&1; return $?
}

_config() {
    git config --global ghq.root "~/src"
}

version() {
    basename "$(readlink /usr/local/opt/ghq)"
}

install() {
    _installed || {
        depend install brew
        depend install git
        depend install go
        brew install ghq 
    }
    _config
}

upgrade() {
    brew outdated "$SETUP_CURRENT_ROLE_NAME" || brew upgrade "$SETUP_CURRENT_ROLE_NAME"
}
