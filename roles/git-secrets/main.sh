#!/bin/bash -u
# See: ../_templates/README.md


_installed() {
    brew list git-secrets > /dev/null 2>&1; return $?
}

_config() {
    git secrets --install --force ~/.git-templates/git-secrets
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
