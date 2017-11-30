#!/usr/bin/env zsh

[ -f ~/.zsh.d/.fzf.zsh ] && source ~/zsh.d/.fzf.zsh

_fzf_default_opts() {
    local base03="234"
    local base02="235"
    local base01="240"
    local base00="241"
    local base0="244"
    local base1="245"
    local base2="254"
    local base3="230"
    local yellow="136"
    local orange="166"
    local red="160"
    local magenta="125"
    local violet="61"
    local blue="33"
    local cyan="37"
    local green="64"
    
    # Solarized Dark color scheme for fzf
    # See also: https://github.com/junegunn/fzf/wiki/Color-schemes#alternate-solarized-lightdark-theme
    local fzf_color="
      --color fg:-1,bg:-1,hl:$blue,fg+:$base2,bg+:$base02,hl+:$blue
      --color info:$yellow,prompt:$yellow,pointer:$base3,marker:$base3,spinner:$yellow
    "

    export FZF_DEFAULT_OPTS="$fzf_color -0 --inline-info --cycle" 
}

_fzf_default_opts
