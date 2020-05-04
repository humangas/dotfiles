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
    brew cask list google-japanese-ime > /dev/null 2>&1; return $?
}

version() {
    ls /usr/local/Caskroom/google-japanese-ime 2>/dev/null
}

install() {
    _installed || {
        depend install brew
        brew cask install google-japanese-ime
    }
}

upgrade() {
    [[ -z $(brew cask outdated "$SETUP_CURRENT_ROLE_NAME") ]] || brew cask reinstall "$SETUP_CURRENT_ROLE_NAME"
}
