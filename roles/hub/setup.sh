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
    brew list hub > /dev/null 2>&1; return $?
}

_config() {
    cp -fr .zsh.d "$HOME/"
}

version() {
    basename "$(readlink /usr/local/opt/hub)"
}

install() {
    _installed || {
        depend install brew
        brew install hub
    }
    _config
}

upgrade() {
    brew outdated "$SETUP_CURRENT_ROLE_NAME" || brew upgrade "$SETUP_CURRENT_ROLE_NAME"
}
