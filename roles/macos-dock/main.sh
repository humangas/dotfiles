#!/bin/bash -u
# See: ../_templates/README.md


version() {
    echo "None"
}

install() {
    # Dock position To bottom
    defaults write com.apple.dock orientation -string "bottom"
    # Automatically hide Dock 
    defaults write com.apple.dock autohide -bool true
    # Zoom icon when on mouse 
    defaults write com.apple.dock magnification -bool true
    # Dock icon zoom size
    defaults write com.apple.dock largesize -float 70
    # Dock icon size
    defaults write com.apple.dock tilesize -float 16
}

upgrade() {
    install
}
