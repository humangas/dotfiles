################################################################################################
# ~/.zshrc
# $ bindkey -L       :Examine key binding
# $ man zsh          :List of zsh manuals and zsh overview
# $ man zshmisc      :Script syntax, how to write redirects and pipes, list of special functions, etc. 
# $ man zshexpn      :Notation of glob and variable expansion 
# $ man zshparam     :List of special variables and notation of suffix expansion of variables  
# $ man zshoptions   :List of options that can be set with setopt  
# $ man zshbuiltins  :List of built-in commands 
################################################################################################
# Env /usr/local/bin
export PATH="/usr/local/bin:$PATH"

# Env go settings
export GOPATH=$HOME
export PATH=$PATH:$GOPATH/bin

## Env oracle client settings
#export ORACLE_HOME=/usr/local/oracle
#export TNS_ADMIN=~/.config/oracle
#export PATH=$ORACLE_HOME:$PATH
#export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$ORACLE_HOME
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME

# Env GNU commands
#export PATH=$(brew --prefix coreutils)/libexec/gnubin:$PATH
#export PATH=$(brew --prefix findutils)/libexec/gnubin:$PATH

# Bindkey
bindkey -v                                             # vi keybind 
bindkey "^[[Z" reverse-menu-complete                   # shift-tab reverse
stty stop undef                                        # disable <C-s>: Stop screen output. 
stty start undef                                       # disable <C-q>: Restart screen output that is stopped.

# Base
autoload -Uz compinit; compinit                        # auto-completion: on
autoload -Uz colors; colors                            # colors: on
setopt no_tify                                         # Notify as soon as the background job is over.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'    # Match to uppercase lowercase conversion (However, distinguish when inputting capital letters)
zstyle ':completion:*:default' menu select=1           # Press <Tab>, you can select the path name from candidates. 
# To enable the completion with sudo command
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                                           /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# Prompt
PROMPT="%U%F{blue}%n%f@%F{cyan}%m:%(5~,%-2~/.../%2~,%~)%f%u"
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true        # Enable %c,%u formatting. If there are uncommitted files in the repository, the string is stored.
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"       # only git add files
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"        # not git add files
zstyle ':vcs_info:*' formats "%F{green}%c%u(%b)%f"     # set $vcs_info_msg_0_
zstyle ':vcs_info:*' actionformats '(%b|%a)'           # This format is displayed at merge conflict.
precmd () { vcs_info }
PROMPT=$PROMPT'${vcs_info_msg_0_}$ '

# Color
eval "$(gdircolors ~/.config/colorscheme/Solarized_dircolors.256dark)"

# Editor
export EDITOR=vim

# History
################################################################################################
# history command same as $ fc -l
# $ history -i            Show execution date and time
# $ history -D            Show the time spent executing
# $ history <fr> <to>     Specify the range and show it
#   e.g. history 1 5      Show from 1st to 5th 
#   e.g. history -5       Show the last 5 
#   e.g. history 1        Show from 1st (= show all) 
#   e.g. history -10 -5   Show from the tenth most recent to the last five most recent history 
################################################################################################
setopt share_history                             # Share history
export HISTFILE=~/.zsh_history                   # Save history file 
export HISTSIZE=10000                            # Number of history items to store in memory
export SAVEHIST=10000                            # Number of records to be saved in history file
setopt hist_ignore_all_dups                      # Duplicate commands delete the old one
setopt hist_ignore_space                         # Beginning starts with a space, do not add it to history.
setopt hist_no_store                             # Do not register the history command in the history.

# # Plugin zplug
# source ~/.zplug/init.zsh
# ## Plugins...
# zplug "zsh-users/zsh-completions"
# zplug "zsh-users/zsh-syntax-highlighting"
#
# ## Install plugins if there are plugins that have not been installed
# if ! zplug check --verbose; then
#     printf "Install? [y/N]: "
#     if read -q; then
#         echo; zplug install
#     fi
# fi
# ## Then, source plugins and add commands to $PATH
# zplug load --verbose

# Alias
# alias ls='gls --color=auto'
# alias ll='ls -la'
# alias sed='/usr/local/bin/gsed'                                             # Dependencies: brew install gnu-sed
# alias grep='/usr/local/bin/ggrep'                                           # Dependencies: brew install grep
# alias vi='vim'
# alias mkdir='mkdirEnhance'
# alias cd='cdEnhance'
# alias fzf='fzf-tmux'                                                        # fzf: /usr/local/Cellar/fzf/0.15.8/bin/fzf
# alias soz='source ~/.zshrc'
# alias mdf='openMdfindFilterFzf'
# alias tmr='tmuxResizePane'
# alias jnb='jupyter notebook --notebook-dir ~/src/work/jupyter'              # Required: $ pip insall jupyter
# alias rmzcompdump='rm -f ~/.zcompdump; rm -f ~/.zplug/zcompdump'            # If tab completion error occurs, delete it. Then reload the zsh.


# Functions
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

# less option
export LESS='-iMR'

# Load fzf (see also: ~/.cache/dein/repos/github.com/junegunn/fzf/shell/key-bindings.zsh)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
_gen_fzf_default_opts() {
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
_gen_fzf_default_opts

# Source ~/.zsh.d/*.sh
setopt nonomatch
if ls ~/.zsh.d/*.sh > /dev/null 2>&1; then
    for file in ~/.zsh.d/*.sh ; do
        [[ -r $file ]] && source "$file"
    done
fi
setopt nomatch
