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
    brew list gpg > /dev/null 2>&1; return $?
}

version() {
    basename "$(readlink /usr/local/opt/gpg)"
}

install() {
    _installed || {
        depend install brew
        depend install curl
        brew install gpg
    }
}

upgrade() {
    brew outdated gpg || {
        brew upgrade gpg
    }
}
