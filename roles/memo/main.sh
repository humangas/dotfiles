#!/usr/bin/env bash -eu
# See: ../_templates/README.md


_installed() {
    type memo > /dev/null 2>&1; return $?
}

_config() {
    cp -r .config "$HOME/"
    brew cask list dropbox > /dev/null 2>&1 && {
        ln -sfnv "$HOME/memo" "$HOME/Dropbox/note"
    }
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
    }
    _config || true
}

upgrade() {
    # TODO: upgrade 処理
    echo "TODO: Implement this function"
}
