#!/usr/bin/env bash -eu
# See: ../_templates/README.md


_installed() {
    brew list awscli > /dev/null 2>&1; return $?
}

version() {
    basename "$(readlink /usr/local/opt/awscli)"
}

install() {
    _installed || {
        depend install brew
        depend install python
        brew install awscli
    }
}

upgrade() {
    brew outdated awscli || {
        brew upgrade awscli
    }
}
