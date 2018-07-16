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
    brew list "$SETUP_CURRENT_ROLE_NAME" > /dev/null 2>&1; return $?
}

version() {
    # basename "$(readlink $(brew --prefix $SETUP_CURRENT_ROLE_NAME 2>/dev/null))"
    basename "$(readlink /usr/local/opt/$SETUP_CURRENT_ROLE_NAME)"
}

config() {
    cp -fr "$SETUP_CURRENT_ROLE_DIR_PATH/.zsh.d" "$HOME/"
    mkdir -p "$NOTE_POST_DIR/_archive"
}

install() {
    depend "install" "brew"
    brew install --HEAD humangas/apps/"$SETUP_CURRENT_ROLE_NAME"
    config
}

upgrade() {
    brew outdated "$SETUP_CURRENT_ROLE_NAME" || brew upgrade "$SETUP_CURRENT_ROLE_NAME"
}
