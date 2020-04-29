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
    [[ "$SETUP_FUNC_NAME" == "install" ]] && return 1
    return 0
}

version() { 
    echo "None"
}

config() {
    _colorscheme() {(
        cd "$SETUP_CURRENT_ROLE_DIR_PATH"

        local profile='Solarized_Dark'
        local filename="$(echo "$profile" | sed -e 's/_/%20/g').terminal"
        local current_profile="$(defaults read com.apple.terminal 'Default Window Settings')"
        local colorscheme_path="$HOME/.config/colorscheme"

        if [ "${current_profile}" != "${profile}" ]; then
            log "INFO" "Setting color scheme for Terminal..."
            curl -sLO "https://raw.githubusercontent.com/tomislav/osx-terminal.app-colors-solarized/master/$filename"
            mv "$filename" "$profile.terminal"
            mkdir -p "$colorscheme_path"
            mv "$profile.terminal" "$colorscheme_path"
            open "$colorscheme_path/$profile.terminal"
            defaults write com.apple.Terminal "Default Window Settings" -string "$profile"
            defaults write com.apple.Terminal "Startup Window Settings" -string "$profile"
        fi

        defaults import com.apple.Terminal "$HOME/Library/Preferences/com.apple.Terminal.plist"
    )}

    _colorscheme

    # Only use UTF-8 in Terminal.app
    defaults write com.apple.terminal StringEncodings -array 4
    # Terminal > Profiles > Shell > When the shell exits: Close the window
    defaults write com.apple.terminal shellExitAction -int 0
}

install() {
    config
}

upgrade() {
    config
}
