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
    type memo > /dev/null 2>&1; return $?
}

_config() {
    cp -r .config "$HOME/"
    ln -sfnv "$HOME/memo" "$HOME/Dropbox/note"
}

version() {
    memo --version | awk '{print $3}'
}

install() {
    _installed || {
        depend install go
        go get -u github.com/mattn/memo
        (
            go get -u -d github.com/humangas/memo-plugin-editg
            cd $GOPATH/src/github.com/humangas/memo-plugin-editg
            make install
        )
        (
            go get -u -d github.com/humangas/memo-plugin-move
            cd $GOPATH/src/github.com/humangas/memo-plugin-move
            make install
        )
        depend install dropbox
    }
    _config
}

upgrade() {
    # TODO: upgrade 処理
    echo "TODO: Implement this function"
}
