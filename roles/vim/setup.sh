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
    [[ $(type $SETUP_CURRENT_ROLE_NAME) == "vim is /usr/local/bin/vim" ]]; return $?
}

version() {
    "$SETUP_CURRENT_ROLE_NAME" --version
}

config() {
    cp "$SETUP_CURRENT_ROLE_DIR_PATH/.vimrc" "$HOME/"
}

install() {
	_install_deinvim() {
		mkdir -p ~/.cache/dein
		(
			cd ~/.cache/dein
			curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
			sh ./install.sh ~/.cache/dein
		)
	}

    depend "install" "brew"
    depend "install" "python3"
    brew install "$SETUP_CURRENT_ROLE_NAME" --with-python3 --with-override-system-vi
    _install_deinvim
    config
}

upgrade() {
    brew outdated "$SETUP_CURRENT_ROLE_NAME" || brew upgrade "$SETUP_CURRENT_ROLE_NAME"
}
