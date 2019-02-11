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
    type poetry "$SETUP_CURRENT_ROLE_NAME" > /dev/null 2>&1; return $?
}

version() {
    "$SETUP_CURRENT_ROLE_NAME" --version
}

config() {
    cp -fr "$SETUP_CURRENT_ROLE_DIR_PATH/.zsh.d" "$HOME/"

    # See also: https://github.com/sdispater/poetry#enable-tab-completion-for-bash-fish-or-zsh
    poetry completion zsh > "$SETUP_CURRENT_ROLE_DIR_PATH/.zsh.d/completion/_poetry"
    cp -fr "$SETUP_CURRENT_ROLE_DIR_PATH/.zsh.d/completion" "$HOME/"

    # TODO: direnvrc for poetry setting
}

install() {
    depend "install" "python"
    depend "install" "direnv"
    # See also: https://github.com/sdispater/poetry#installation 
    curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python
    config
}

upgrade() {
    "$SETUP_CURRENT_ROLE_NAME" self:update
}
