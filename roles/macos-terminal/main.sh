#!/bin/bash -u
# See: ../_templates/README.md


_colorscheme() {
    local profile='Solarized_Dark'
    local filename="$(echo "$profile" | sed -e 's/_/%20/g').terminal"
    local current_profile="$(defaults read com.apple.terminal 'Default Window Settings')"
    local colorscheme_path="$HOME/.config/colorscheme"

    if [ "${current_profile}" != "${profile}" ]; then
        log INFO "Setting color scheme for Terminal..."
        mkdir -p "$colorscheme_path"
        curl -sL -o "$colorscheme_path/$profile.terminal" "https://raw.githubusercontent.com/tomislav/osx-terminal.app-colors-solarized/master/$filename"
        open "$colorscheme_path/$profile.terminal"
        defaults write com.apple.Terminal "Default Window Settings" -string "$profile"
        defaults write com.apple.Terminal "Startup Window Settings" -string "$profile"
    fi

    defaults import com.apple.Terminal "$HOME/Library/Preferences/com.apple.Terminal.plist"
}

version() { 
    echo "None"
}

install() {
    _colorscheme

    # Only use UTF-8 in Terminal.app
    defaults write com.apple.terminal StringEncodings -array 4
    # Terminal > Profiles > Shell > When the shell exits: Close the window
    defaults write com.apple.terminal shellExitAction -int 0
}

upgrade() {
    install
}
