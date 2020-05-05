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
    brew list git-secrets > /dev/null 2>&1; return $?
}

_config() {
    git secrets --install ~/.git-templates/git-secrets
    git config --global init.templateDir ~/.git-templates/git-secrets
}

version() {
    basename "$(readlink /usr/local/opt/git-secrets)"
}

install() {
    _installed || {
        depend install brew
        depend install git
        brew install git-secrets
    }
    _config
}

upgrade() {
    brew outdated git-secrets || {
        brew upgrade git-secrets
    }
}
