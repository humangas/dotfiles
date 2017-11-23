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
    brew cask list "$SETUP_CURRENT_ROLE_NAME" > /dev/null 2>&1; return $?
}

version() {
    brew cask info "$SETUP_CURRENT_ROLE_NAME"
}

config() {
    return
}

install() {
    depend "install" "brew"
    brew cask install "$SETUP_CURRENT_ROLE_NAME" >/dev/null 2>&1
    [[ "$?" -eq 0 ]] || caveats "WARN" "- $SETUP_CURRENT_ROLE_NAME: Open Security & Privacy > Click Allow button, brew cask install $SETUP_CURRENT_ROLE_NAME"
    config
}

upgrade() {
    [[ -z $(brew cask outdated "$SETUP_CURRENT_ROLE_NAME") ]] || brew cask reinstall --force "$SETUP_CURRENT_ROLE_NAME"
}
