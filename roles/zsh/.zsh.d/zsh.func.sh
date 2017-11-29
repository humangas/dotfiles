#!/usr/bin/env zsh

function mkdirEnhance() {
    case $1 in
        -w)
            local dirname=$2
            if [[ -z $dirname ]]; then
                echo 'Usage: mkdir -w DIRNAME'
                return 1
            fi
            mkdir -p "$GOPATH/src/work/$dirname"
            cd $_
            git init
            ;;
        --help)
            local _help=$(/usr/local/opt/coreutils/libexec/gnubin/mkdir --help)
            echo $_help | sed -e '5i \　-w  DIRNAME   　  creating DIRNAME directory under $GOPATH/src/work and move it.'
            ;;
        *)
            /usr/local/opt/coreutils/libexec/gnubin/mkdir $@
            ;;
    esac
}

function cdEnhance() {
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
  -w, --work          List \$GOPATH/src/work list
  -g, --git           Open git url
  --                  List history
  **                  Subsequently press tab, fzf mode will be set
"
}

function _cdGhqDir(){
    local ghqlist=`ghq list`
    local worklist=$(ls -d $GOPATH/src/work/* | sed -e "s@$GOPATH/src/@@")
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

function tmuxResizePane() {
    local pane=$1
    local size=$2
    local showUsage=1
    local inputPane=1
    local inputSize=1
    
    [[ $1 =~ "^[U|D|L|R]$" ]] && inputPane=0
    [[ $2 =~ "^([5-9]|[1-9][0-9]|100)$" ]] && inputSize=0
    [[ $inputPane -eq 0 && $inputSize -eq 0 ]] && showUsage=0
    [[ $showUsage -ne 0 ]] && _tmuxResizePaneUsage

    if [[ $inputPane -eq 1 ]]; then
        printf "PANE: "
        read -t 10 pane
        case $pane in
            U|D|L|R) ;;
            ''|*) return 1 ;;
        esac
    fi

    if [[ $inputSize -eq 1 ]]; then
        printf "SIZE: "
        read -t 10 size 
        case $size in
            [5-9]|[1-9][0-9]|100) ;;
            ''|*) return 1 ;;
        esac
    fi

    tmux resize-pane -$pane $size
}

function _tmuxResizePaneUsage() {
echo 'Usage: tmr PANE SIZE" 
   tmr command is tmux resize pane.
   - PANE:  U(UP), D(Down), L(Left), R(Right)"
   - SIZE:  5 - 100"
'
}

function openMdfindFilterFzf(){
    if [[ $# -eq 0 ]]; then
        mdfind
        return $?
    fi

    local T="$(mdfind $@ | fzf)"
    [[ ! -z $T ]] && open $T
}

