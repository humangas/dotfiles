#!/usr/bin/env zsh

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
