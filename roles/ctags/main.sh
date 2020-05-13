#!/usr/bin/env bash -eu
# See: ../_templates/README.md


_installed() {
    brew list ctags > /dev/null 2>&1; return $?
}

version() {
    basename "$(readlink /usr/local/opt/ctags)"
}

install() {
    _installed || {
        depend install brew
        brew install ctags
    }
}

upgrade() {
    brew outdated ctags || {
        brew upgrade ctags
    }
}
