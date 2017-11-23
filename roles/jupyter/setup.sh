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
    if type pip > /dev/null 2>&1; then
        pip show "$SETUP_CURRENT_ROLE_NAME" > /dev/null 2>&1
        return $?
    fi
    return 1
}

version() {
    pip show "$SETUP_CURRENT_ROLE_NAME" | grep 'Version'
}

config() {
    # depend "config" "note"
    cp "$SETUP_CURRENT_ROLE_DIR_PATH/jupyter.alias.sh" "$HOME/note"
}

install() {
    depend "install" "python"
    (
        source ~/.zsh.d/python.sh
        pip install "$SETUP_CURRENT_ROLE_NAME"
    )
    config
}

upgrade() {
    pip install -U "$SETUP_CURRENT_ROLE_NAME"
}
