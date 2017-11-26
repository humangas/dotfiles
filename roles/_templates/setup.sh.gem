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
    if type gem > /dev/null 2>&1; then
        [[ -z $(gem list --local "$SETUP_CURRENT_ROLE_NAME" | tail -n 1) ]] && return 1 || return 0
    fi
    return 1
}

version() {
    gem list --local "$SETUP_CURRENT_ROLE_NAME" | head -n 1 | sed "s/$SETUP_CURRENT_ROLE_NAME //" | sed -e "s/[()]//g"
}

config() {
    return
}

install() {
    depend "install" "ruby"
    gem install "$SETUP_CURRENT_ROLE_NAME"
    config
}

upgrade() {
    install
}
