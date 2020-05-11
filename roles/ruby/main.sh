#!/bin/bash -u
# See: ../_templates/README.md


_installed() {
    brew list ruby > /dev/null 2>&1; return $?
}

version() {
    basename "$(readlink /usr/local/opt/ruby)"
}

install() {
    _installed || {
        depend install brew
        brew install ruby
    }
}

upgrade() {
    brew outdated ruby || {
        brew upgrade ruby
    }
}
