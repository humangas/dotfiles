#!/bin/bash -u
# See: ../_templates/README.md


_installed() {
    brew list gibo > /dev/null 2>&1; return $?
}

_config() {
    cp -fr .gitignore-boilerplates "$HOME/"
}

version() {
    basename "$(readlink /usr/local/opt/gibo)"
}

install() {
    _installed || {
        depend install brew
        depend install git
        brew install gibo
    }
    _config
}

upgrade() {
    brew outdated gibo || {
        brew upgrade gibo
    }
    gibo update
}
