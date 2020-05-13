#!/usr/bin/env bash -eu
# See: ../_templates/README.md


_installed() {
    type brew > /dev/null 2>&1; return $?
}

version() {
    brew --version | sed "s/Homebrew //"
}

install() {
    _installed || {
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    }
}

upgrade() {
    brew update
}
