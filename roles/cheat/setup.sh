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
    type "$SETUP_CURRENT_ROLE_NAME" > /dev/null 2>&1; return $?
}

version() {
    "$SETUP_CURRENT_ROLE_NAME" --version
}

config() {
    return
}

install() {
    depend "install" "ghq"
    ghq get git@github.com:humangas/cheat.git
    (
    cd $GOPATH/src/github.com/humangas/cheat
    make install
    )
    config
}

upgrade() {
    install
}