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
    brew cask list "$SETUP_CURRENT_ROLE_NAME" > /dev/null 2>&1; return $?
}

version() {
    brew cask info "$SETUP_CURRENT_ROLE_NAME"
}

config() {
    return
}

# install() {
# 	# sudo spctl --master-enable | --master-disable
#     depend "install" "brew"
#     brew cask install "$SETUP_CURRENT_ROLE_NAME" >/dev/null 2>&1
#     security_and_privacy "reload"
#     [[ "$?" -eq 9 ]] && return $?
#     brew cask reinstall --force "$SETUP_CURRENT_ROLE_NAME"
#     config
# }

install() {
    depend "install" "brew"
	sudo spctl --master-disable
    brew cask install "$SETUP_CURRENT_ROLE_NAME" >/dev/null 2>&1
    [[ "$?" -eq 0 ]] || log "WARN" "Open Security & Privacy > Click Allow button, brew cask install $SETUP_CURRENT_ROLE_NAME"
	sudo spctl --master-enable
    config
}

upgrade() {
    [[ -z $(brew cask outdated "$SETUP_CURRENT_ROLE_NAME") ]] || brew cask reinstall --force"$SETUP_CURRENT_ROLE_NAME"
}

security_and_privacy() {
    _load() {
        log "INFO" "Loading Kernel Extentions"
        sudo kextload "/Library/Application Support/VirtualBox/VBoxDrv.kext" -r "/Library/Application Support/VirtualBox/"
        sudo kextload "/Library/Application Support/VirtualBox/VBoxNetAdp.kext" -r "/Library/Application Support/VirtualBox/"
        sudo kextload "/Library/Application Support/VirtualBox/VBoxNetFlt.kext" -r "/Library/Application Support/VirtualBox/"
        sudo kextload "/Library/Application Support/VirtualBox/VBoxUSB.kext" -r "/Library/Application Support/VirtualBox/"
    }

    _unload() {
        if [ $(ps -ef | grep -c 'VirtualBox$') -ne 0 ]; then
            log "ERROR" "Error: VirtualBox still seems to be running. Please investigate!!"
            return 9;
        elif [ `ps -ef | grep -c [V]ir` -gt 0 ]; then
            log "INFO" "Stopping running processes before unloading Kernel Extensions"
            ps -ef | grep '[V]ir' | awk '{print $2}' | xargs kill
        fi
        log "INFO" "Unloading Kernel Extensions"
        kextstat | grep "org.virtualbox.kext.VBoxUSB" > /dev/null 2>&1 && sudo kextunload -b org.virtualbox.kext.VBoxUSB
        kextstat | grep "org.virtualbox.kext.VBoxNetFlt" > /dev/null 2>&1 && sudo kextunload -b org.virtualbox.kext.VBoxNetFlt
        kextstat | grep "org.virtualbox.kext.VBoxNetAdp" > /dev/null 2>&1 && sudo kextunload -b org.virtualbox.kext.VBoxNetAdp
        kextstat | grep "org.virtualbox.kext.VBoxDrv" > /dev/null 2>&1 && sudo kextunload -b org.virtualbox.kext.VBoxDrv
    }

    case "$1" in
        unload|remove) _unload ;;
        load) _load ;;
        *|reload) _unload; _load ;;
    esac
}
