#!/bin/bash -u
# See: ../_templates/README.md


_installed() {
    brew list tmux > /dev/null 2>&1; return $?
}

_is_installed_reattach-to-user-namespace() {
    type reattach-to-user-namespace > /dev/null 2>&1; return $?
}

_is_installed_ansifilter() {
    type ansifilter > /dev/null 2>&1; return $?
}

_config() {
    cp -fr .zsh.d "$HOME/"
    cp .tmux.conf "$HOME/"
}

version() {
    basename "$(readlink /usr/local/opt/tmux)"
}

install() {
    _installed || {
        depend install brew
        brew install tmux
        _is_installed_reattach-to-user-namespace || brew install reattach-to-user-namespace
        # ansifilter for tmux-plugins/tmux-logging
        _is_installed_ansifilter || brew install ansifilter
        depend install git
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    }
    _config
}

upgrade() {
    brew outdated tmux || {
        brew upgrade tmux
    }
    _is_installed_reattach-to-user-namespace && {
        (brew outdated reattach-to-user-namespace || brew upgrade reattach-to-user-namespace)
    }
    _is_installed_ansifilter && {
        (brew outdated ansifilter || brew upgrade ansifilter)
    }
}
