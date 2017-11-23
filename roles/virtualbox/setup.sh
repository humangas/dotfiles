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
    if type "$SETUP_CURRENT_ROLE_NAME" > /dev/null 2>&1; then
        return 0 
    fi
    if type brew > /dev/null 2>&1; then
        brew cask list "$SETUP_CURRENT_ROLE_NAME" > /dev/null 2>&1
        return $?
    fi
    return 1
}

version() {
    brew cask info "$SETUP_CURRENT_ROLE_NAME"
}

config() {
    return
}

install() {
    depend "install" "brew"
    brew cask install "$SETUP_CURRENT_ROLE_NAME" >/dev/null 2>&1
    local retval="$?"
    config
    local warnmsg="- $SETUP_CURRENT_ROLE_NAME: Manual Operation => Open Security & Privacy > Click Allow button, brew cask install $SETUP_CURRENT_ROLE_NAME"
    [[ "$retval" -eq 0 ]] || caveats "WARN" "$warnmsg"
}

upgrade() {
    [[ -z $(brew cask outdated "$SETUP_CURRENT_ROLE_NAME") ]] || brew cask reinstall --force "$SETUP_CURRENT_ROLE_NAME"
}
