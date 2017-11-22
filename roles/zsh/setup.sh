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
    [[ $(type $SETUP_CURRENT_ROLE_NAME) == "zsh is /usr/local/bin/zsh" ]]; return $?
}

version() {
    "$SETUP_CURRENT_ROLE_NAME" --version
}

config() {
    mkdir -p "$HOME/.zsh.d"
    cp "$SETUP_CURRENT_ROLE_DIR_PATH/.zshrc" "$HOME/"
}

install() {
    depend "install" "brew"
    # --without-etcdir: Disable the reading of Zsh rc files in /etc
    brew install "$SETUP_CURRENT_ROLE_NAME" --without-etcdir
    local login_shell='/usr/local/bin/zsh'
    [[ "$login_shell" != "$SHELL" ]] && sudo chsh -s "$login_shell"
    config
}

upgrade() {
    brew outdated "$SETUP_CURRENT_ROLE_NAME" || brew upgrade "$SETUP_CURRENT_ROLE_NAME"
}
