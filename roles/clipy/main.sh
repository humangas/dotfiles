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
    brew cask list clipy > /dev/null 2>&1; return $?
}

version() {
    ls /usr/local/Caskroom/clipy 2>/dev/null
}

install() {
    _installed || {
        depend install brew
        brew cask install clipy
    }
}

upgrade() {
    [[ -z $(brew cask outdated clipy) ]] || {
        brew cask upgrade clipy
    }
}
