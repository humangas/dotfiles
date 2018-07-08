# zsh
おなじみ [Z shell](https://ja.wikipedia.org/wiki/Z_Shell)

.zshrc 設定内容

## 重複登録しない
```
typeset -U path cdpath fpath manpath
```

## vi バインドキー
```
bindkey -v
```

## Shift Tab で戻る
```
bindkey "^[[Z" reverse-menu-complete
```

## disable `<C-s>`: Stop screen output. 
```
stty stop undef
```

## disable `<C-q>`: Restart screen output that is stopped.
```
stty start undef                                       
```
 
## auto-completion: on
```
autoload -Uz compinit; compinit                        
```

## colors: on
```
autoload -Uz colors; colors                            
```

## Notify as soon as the background job is over.
```
setopt no_tify                                         
```

## Match to uppercase lowercase conversion (However, distinguish when inputting capital letters)
```
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'    
```

## Press `<Tab>`, you can select the path name from candidates. 
```
zstyle ':completion:*:default' menu select=1           
```

## To enable the completion with sudo command
```
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                                           /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
```

## Prompt
```
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
```

これでgitの状態を表示できたり、長いパスを...で省略できたりする。以下のプロンプトになる。

```
humangas@gray:~/src/.../golang/lint(master)$ pwd
/Users/humangas/src/github.com/golang/lint
```

## カラースキーマ設定
```
eval "$(gdircolors ~/.config/colorscheme/Solarized_dircolors.256dark)"
```

Mac デフォだと、BSD のls コマンドを使用しており、ls カラー設定するためのgdircolors コマンドが使えないので、GNU版のls を入れることにする。
GNU 版ls（gls）とかが入ってるcoreutils をインストール
```
$ brew install coreutils
```

`~/.config/colorscheme/Solarized_dircolors.256dark`は、以下でDLしているという前提。

- [zsh/setu.sh#L25: setting colorscheme](https://github.com/humangas/dotfiles/blob/467bb2781d1dacc65e167e3470db7fe0157ac0b7/roles/zsh/setup.sh#L25)

```
    _colorscheme() {
        local _filename="dircolors.256dark"
        local filename="Solarized_$_filename"
        local colorscheme_path="$HOME/.config/colorscheme"

        log "INFO" "Setting color scheme for zsh..."
        curl -sLO "https://raw.githubusercontent.com/seebi/dircolors-solarized/master/$_filename"
        mv "$_filename" "$filename" 
        mkdir -p "$colorscheme_path"
        mv "$filename" "$colorscheme_path/$filename"
    }
```


## Editorをvimに設定（稀にこの環境変数を見ているツールがいるため）
```
export EDITOR=vim
```

## 履歴設定: Share history
```
setopt share_history
```

## 履歴設定: Save history file 
```
export HISTFILE=~/.zsh_history                   
```

## 履歴設定: Number of history items to store in memory 
```
export HISTSIZE=10000                            
```

## 履歴設定: Number of records to be saved in history file
```
export SAVEHIST=10000                            
```

## 履歴設定: Duplicate commands delete the old one
```
setopt hist_ignore_all_dups                      
```

## 履歴設定: Beginning starts with a space, do not add it to history.
```
setopt hist_ignore_space                         
```

## 履歴設定: Do not register the history command in the history.
```
setopt hist_no_store                             
```

## less command options
```
export LESS='-iMR'
```

