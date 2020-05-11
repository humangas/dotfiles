#!/bin/bash -u
# See: ../_templates/README.md


_installed() {
    brew list zsh > /dev/null 2>&1; return $?
}

_config() {
    cp -fr .zsh.d "$HOME/"
    cp -f .zshrc "$HOME/"
}

_colorscheme() {
    local _filename="dircolors.256dark"
    local filename="Solarized_$_filename"
    local colorscheme_path="$HOME/.config/colorscheme"

    log INFO "Setting color scheme for zsh..."
    curl -sLO "https://raw.githubusercontent.com/seebi/dircolors-solarized/master/$_filename"
    mv "$_filename" "$filename" 
    mkdir -p "$colorscheme_path"
    mv "$filename" "$colorscheme_path/$filename"
}

version() {
    basename "$(readlink /usr/local/opt/zsh)"
}

install() {
    _installed || {
        depend install brew
        brew install zsh
        log WARN "Caveats: change login shell: $ sudo chsh -s /usr/local/bin/zsh"
    }
    _colorscheme
    _config
}

upgrade() {
    brew outdated zsh || {
        brew upgrade zsh
    }
}
