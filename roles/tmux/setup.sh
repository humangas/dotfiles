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

_is_installed_reattach-to-user-namespace() {
    type reattach-to-user-namespace > /dev/null 2>&1; return $?
}

version() {
    "$SETUP_CURRENT_ROLE_NAME" -V
}

config() {
    depend "config" "go"
    cp "$SETUP_CURRENT_ROLE_DIR_PATH/.tmux.conf" "$HOME/"
    chmod u+x "$SETUP_CURRENT_ROLE_DIR_PATH/bin/"*
    cp -p "$SETUP_CURRENT_ROLE_DIR_PATH/bin/"* "$HOME/bin/"
}

install() {
    depend "install" "brew" 
    depend "install" "zsh"
    brew install "$SETUP_CURRENT_ROLE_NAME"
    _is_installed_reattach-to-user-namespace || brew install reattach-to-user-namespace
    config
}

upgrade() {
    brew outdated "$SETUP_CURRENT_ROLE_NAME" || brew upgrade "$SETUP_CURRENT_ROLE_NAME"
    _is_installed_reattach-to-user-namespace && brew outdated reattach-to-user-namespace || brew upgrade reattach-to-user-namespace
}
