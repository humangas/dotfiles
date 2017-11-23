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
    [[ $(type $SETUP_CURRENT_ROLE_NAME) == "zsh is /usr/local/bin/zsh" ]]; return $?
}

version() {
    "$SETUP_CURRENT_ROLE_NAME" --version
}

config() {
    mkdir -p "$HOME/.zsh.d"
    cp "$SETUP_CURRENT_ROLE_DIR_PATH/.zshrc" "$HOME/"
    cp "$SETUP_CURRENT_ROLE_DIR_PATH/zsh.alias.sh" ~/.zsh.d/
}

install() {
    _colorscheme() {
        local _filename="dircolors.256dark"
        local filename="Solarized_$_filename"
        local colorscheme_path="$HOME/.config/colorscheme"

        log "INFO" "Setting color scheme for zsh..."
        curl -sLO "https://raw.githubusercontent.com/seebi/dircolors-solarized/master/$_filename"
        mv "$_filename" "$filename" 
        mkdir -p "$colorscheme_path"
        mv "$filename" "$colorscheme_path/$filename"
    }

    depend "install" "brew"
    # --without-etcdir: Disable the reading of Zsh rc files in /etc
    brew install "$SETUP_CURRENT_ROLE_NAME" --without-etcdir
    local login_shell='/usr/local/bin/zsh'
    sudo dscl . -create /Users/$USER UserShell "$login_shell"

    _colorscheme
    config
}

upgrade() {
    brew outdated "$SETUP_CURRENT_ROLE_NAME" || brew upgrade "$SETUP_CURRENT_ROLE_NAME"
}
