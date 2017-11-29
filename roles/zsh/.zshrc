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
# Not duplicate registration
typeset -U path cdpath fpath manpath

# Env /usr/local/bin
export PATH="/usr/local/bin:$PATH"

## Env oracle client settings
#export ORACLE_HOME=/usr/local/oracle
#export TNS_ADMIN=~/.config/oracle
#export PATH=$ORACLE_HOME:$PATH
#export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$ORACLE_HOME
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME

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
alias mkdir='mkdirEnhance'
alias cd='cdEnhance'
alias mdf='openMdfindFilterFzf'
alias tmr='tmuxResizePane'
# alias jnb='jupyter notebook --notebook-dir ~/src/work/jupyter'              # Required: $ pip insall jupyter
# alias rmzcompdump='rm -f ~/.zcompdump; rm -f ~/.zplug/zcompdump'            # If tab completion error occurs, delete it. Then reload the zsh.


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
