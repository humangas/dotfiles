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
    brew list ed > /dev/null 2>&1; return $?
}

version() {
    basename "$(readlink /usr/local/opt/ed)"
}

install() {
    _installed || {
        depend install brew
        brew install ed --with-default-names
    }
}

upgrade() {
    brew outdated ed || {
        brew upgrade ed
    }
}
