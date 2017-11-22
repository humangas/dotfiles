#!/bin/bash
###################################################################################
# Usage: source from roles/setup.sh
# The "log", "depend" function in roles/setup.sh can be used from within this file.
###################################################################################
SETUP_CURRENT_ROLE_FILE_PATH="$BASH_SOURCE"

is_installed() {
    brew cask list "$SETUP_CURRENT_ROLE_NAME" > /dev/null 2>&1; return $?
}

config() {
    return
}

version() {
    brew cask info "$SETUP_CURRENT_ROLE_NAME"
}

install() {
    depend "install" "brew"
    brew cask install "$SETUP_CURRENT_ROLE_NAME"
    config
}

upgrade() {
    [[ -z $(brew cask outdated "$SETUP_CURRENT_ROLE_NAME") ]] || brew cask reinstall "$SETUP_CURRENT_ROLE_NAME"
}
