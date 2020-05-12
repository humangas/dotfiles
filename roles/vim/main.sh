#!/usr/bin/env bash -eu
# See: ../_templates/README.md


_installed() {
    brew list vim > /dev/null 2>&1; return $?
}

_config() {
    cp .vimrc "$HOME/"
}

_install_vimplug() {
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

version() {
    basename "$(readlink /usr/local/opt/vim)"
}

install() {
    _installed || {
        depend install brew
        depend install python
        depend install ctags # For Plugin: szw/vim-tags
        depend install lua   # For plugin: Shougo/neocomplete.vim
        brew install vim
        _install_vimplug
        depend install go    # For vim plugin, see below
        # TODO: ほぼ使わないので削除する: vimrc も同時に見直す
        # go get -u github.com/fatih/hclfmt
        # TODO: すでに非推奨なので、推奨を使う。vimrc も同時に整理する
        # => https://github.com/golangci/golangci-lint
        # go get -u gopkg.in/alecthomas/gometalinter.v2
        # gometalinter --install --update
    }
    _config
}

upgrade() {
    brew outdated vim || {
        brew upgrade vim
    }
    # TODO: install 参照（そこと同じ整理をする）
    # go get -u github.com/fatih/hclfmt              # For plugin: fatih/vim-hclfmt
    # go get -u gopkg.in/alecthomas/gometalinter.v2  # For plugin: w0rp/ale, go linter
    # gometalinter --install --update
}
