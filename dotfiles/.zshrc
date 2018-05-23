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
export PATH="/usr/local/bin:/sbin:/usr/sbin/:$PATH"

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

# Command options
export LESS='-iMR'

# Extensions
build_extensions() {
    echo "Build .{env,alias,function} files form under the .zsh.d directory"
    [[ ! -e $HOME/.zsh.d ]] && return
    rm -rf $HOME/.{env,alias,function}
    local sh type
    for sh in $(find $HOME/.zsh.d -type f -name "*sh"); do
        type=$(printf $(basename $sh) | cut -d. -f2)
        case $type in
            env|alias|function) 
                echo "# $sh" >> $HOME/.$type
                cat $sh >> $HOME/.$type
                echo -e "\n" >> $HOME/.$type
                ;;
            *)
                echo "[WARN] Undefined type: $type ($sh)"
                ;;
        esac
    done
    if [[ -e $HOME/.function ]]; then
        sed -i -e "s@^#\!.*@@g" $HOME/.function
        sed -i -e '1s@^@#\!/user/bin/env zsh\n@' $HOME/.function
    fi
}

source_extensions() {
    echo "Source .{env,alias,function} files"
    setopt nonomatch
    for f in ~/.{env,alias,function}; do
        [[ -r $f ]] && source "$f"
    done
    setopt nomatch
}

ssh_add_keys() {
    setopt nonomatch
    if `ls ~/.ssh/*.pem >/dev/null 2>&1`; then
        ssh-add ~/.ssh/*.pem
    fi
    setopt nomatch
}

alias soz='source ~/.zshrc'
build_extensions && source_extensions
ssh_add_keys

