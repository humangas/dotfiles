#!/usr/bin/env zsh

alias mkdir='mkdirex'

function mkdirex() {
    case $1 in
        -w)
            local dirname=$2
            if [[ -z $dirname ]]; then
                echo 'Usage: mkdir -w DIRNAME'
                return 1
            fi
            mkdir -p "$GOPATH/src/work/_/$dirname"
            cd $_
            git init
            ;;
        --help)
            local _help=$(/usr/local/opt/coreutils/libexec/gnubin/mkdir --help)
            echo $_help | sed -e '5i \　-w  DIRNAME   　  creating DIRNAME directory under $GOPATH/src/work/_/ and move it.'
            ;;
        *)
            /usr/local/opt/coreutils/libexec/gnubin/mkdir $@
            ;;
    esac
}
