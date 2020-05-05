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
    brew list vim > /dev/null 2>&1; return $?
}

_config() {
    cp .vimrc "$HOME/"
}

version() {
    basename "$(readlink /usr/local/opt/vim)"
}

install() {
	_install_vimplug() {
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	}

    _installed || {
        depend install brew
        depend install python
        depend install ctags # For Plugin: szw/vim-tags
        depend install sass  # For plugin: AtsushiM/sass-compile.vim
        depend install lua   # For plugin: Shougo/neocomplete.vim
        brew install vim --with-python3 --with-lua --with-override-system-vi
        _install_vimplug
        depend install go    # For vim plugin, see below
        go get -u github.com/fatih/hclfmt
        go get -u gopkg.in/alecthomas/gometalinter.v2
        gometalinter --install --update
    }
    _config
}

upgrade() {
    brew outdated vim || {
        brew upgrade vim
    }
    go get -u github.com/fatih/hclfmt              # For plugin: fatih/vim-hclfmt
    go get -u gopkg.in/alecthomas/gometalinter.v2  # For plugin: w0rp/ale, go linter
    gometalinter --install --update
}
