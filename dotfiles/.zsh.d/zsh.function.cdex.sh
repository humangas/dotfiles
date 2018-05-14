#!/usr/bin/env zsh

alias cd='cdex'

function cdex() {
    case $1 in
        --help) _cdEnhanceUsage ;;
        -s|--src) _cdGhqDir ;;
        -w|--work) _openWorkDir ;;
        -g|--git) _openCurrentGitURL ;;
        --)
            local dir
            dir="$(fasd -Rdl "$1" | fzf -1 -0 --no-sort +m)" && cd "${dir}" || return 1
            ;;
        *) builtin cd $@ ;;
    esac
}

function _cdEnhanceUsage() {
echo "Usage: cd [options] [dir]

options:
  -s, --src           List \$GOPATH/src list
  -w, --work          List \$GOPATH/src/work/*/ list
  -g, --git           Open git url
  --                  List history
  **                  Subsequently press tab, fzf mode will be set
"
}

function _cdGhqDir(){
    local ghqlist=`ghq list`
    if [[ -e $GOPATH/src/work && $(ls $GOPATH/src/work | wc -l) -gt 0 ]]; then
        local worklist=$(ls -d $GOPATH/src/work/* | sed -e "s@$GOPATH/src/@@")
    fi
    local alllist="$ghqlist\n$worklist"
    local mvdir=$(echo -e "$alllist" | sort | uniq \
            | fzf -0 --inline-info --ansi --cycle --preview "ls -la $GOPATH/src/{}")

    [[ -z $mvdir ]] && return 1
    cd "$GOPATH/src/$mvdir"
}

function _openWorkDir() {
    local select=$(ghq list | ag work/ | fzf)
    [[ -z $select ]] && return 1
    cd $GOPATH/src/$select
}

function _openCurrentGitURL() {
    local url=$(git config -l | grep remote.origin.url | cut -d= -f2)

    if [[ ! -n $url ]]; then
        echo "Error! git remote.origin.url not found"
        return 1
    fi
  
    if [[ -n $(echo $url | grep 'http') ]]; then
        open "$url"
    elif [[ -n $(echo $url | grep 'ssh') ]]; then
        url=$(echo "$url" | sed "s/ssh:/https:/" | sed "s/git@//")
        open "$url"
    elif [[ -n $(echo $url | grep 'git') ]]; then
        url=$(echo "$url" | sed "s/:/\//" | sed "s/git@/https:\/\//")
        open "$url"
    else
        echo "Error! Unexpected form: $url" 
        return 1
    fi
}

function openMdfindFilterFzf(){
    if [[ $# -eq 0 ]]; then
        mdfind
        return $?
    fi

    local T="$(mdfind $@ | fzf)"
    [[ ! -z $T ]] && open $T
}
