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
    brew list "$SETUP_CURRENT_ROLE_NAME" > /dev/null 2>&1; return $?
}

_config() {
    cp .tigrc "$HOME/"
}

version() {
    basename "$(readlink /usr/local/opt/tig)"
}

install() {
    depend "install" "brew"
    depend "install" "git"
    brew install "$SETUP_CURRENT_ROLE_NAME"
    _config
}

upgrade() {
    brew outdated "$SETUP_CURRENT_ROLE_NAME" || brew upgrade "$SETUP_CURRENT_ROLE_NAME"
}
