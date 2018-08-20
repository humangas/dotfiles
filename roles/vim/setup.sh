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
is_installed() {
    brew list "$SETUP_CURRENT_ROLE_NAME" > /dev/null 2>&1; return $?
}

version() {
    basename "$(readlink /usr/local/opt/$SETUP_CURRENT_ROLE_NAME)"
}

config() {
    cp "$SETUP_CURRENT_ROLE_DIR_PATH/.vimrc" "$HOME/"
}

install() {
	_install_vimplug() {
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	}

    depend "install" "brew"
    depend "install" "python3"
    depend "install" "ctags" # For Plugin: szw/vim-tags
    depend "install" "sass"  # For plugin: AtsushiM/sass-compile.vim
    depend "install" "lua"   # For plugin: Shougo/neocomplete.vim
    brew install "$SETUP_CURRENT_ROLE_NAME" --with-python3 --with-lua --with-override-system-vi
    _install_vimplug
    depend "install" "go"               # For plugin: fatih/vim-hclfmt
    go get -u github.com/fatih/hclfmt
    config
}

upgrade() {
    brew outdated "$SETUP_CURRENT_ROLE_NAME" || brew upgrade "$SETUP_CURRENT_ROLE_NAME"
    go get -u github.com/fatih/hclfmt   # For plugin: fatih/vim-hclfmt
}
