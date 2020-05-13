#!/usr/bin/env bash -eu
# See: ../_templates/README.md


version() {
    echo "None"
}

install() {
    DOTF_COMPUTER_NAME="${DOTF_COMPUTER_NAME:-`date '+%Y%m%d%H%M%S'`}"
    log WARN "Caveats: set ComputerName: $ sudo scutil --set ComputerName $DOTF_COMPUTER_NAME"
    log WARN "Caveats: set HostName: $ sudo scutil --set HostName $DOTF_COMPUTER_NAME"
    log WARN "Caveats: set LocalHostName: $ sudo scutil --set LocalHostName $DOTF_COMPUTER_NAME"
    log WARN "Caveats: set NetBIOSName: $ sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $DOTF_COMPUTER_NAME"
}

upgrade() {
    install
}
