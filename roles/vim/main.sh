#!/usr/bin/env bash -eu
# See: ../_templates/README.md


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
        depend install lua   # For plugin: Shougo/neocomplete.vim
        brew install vim --with-lua --with-override-system-vi
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
