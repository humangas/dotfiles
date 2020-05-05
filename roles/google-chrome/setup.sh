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
    brew cask list google-chrome > /dev/null 2>&1; return $?
}

version() {
    ls /usr/local/Caskroom/google-chrome 2>/dev/null
}

install() {
    _installed || {
        depend install brew
        brew cask install google-chrome
    }
}

upgrade() {
    [[ -z $(brew cask outdated google-chrome) ]] || {
        brew cask upgrade google-chrome 
    }
}
