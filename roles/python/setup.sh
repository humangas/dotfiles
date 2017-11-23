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
is_installed() {
    [[ $(type $SETUP_CURRENT_ROLE_NAME) == "python is /usr/local/opt/python/libexec/bin/python" ]]; return $?
}

version() {
    "$SETUP_CURRENT_ROLE_NAME" --version
}

config() {
    depend "config" "zsh"
    cp "$SETUP_CURRENT_ROLE_DIR_PATH/python.sh" ~/.zsh.d/
}

install() {
    depend "install" "brew"
    brew install "$SETUP_CURRENT_ROLE_NAME"
    config
}

upgrade() {
    brew outdated "$SETUP_CURRENT_ROLE_NAME" || brew upgrade "$SETUP_CURRENT_ROLE_NAME"
}