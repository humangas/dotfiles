# tmux
おなじみのターミナルマルチプレクサ

.tmux.conf 設定内容

## tmux default shell set zsh.
```
set-option -g default-shell /usr/local/bin/zsh                                                    
```

## vi keybind
```
set-window-option -g mode-keys vi                                                                 
```

## Shared clipboard: vim - tmux.
```
set-option -g default-command "reattach-to-user-namespace -l $SHELL"                              
```

## fix Esc key delay time for Vim
```
set -sg escape-time 0                                                                             
```

## To Start the index of window from 1.  
```
set -g base-index 1                                                                               
```

## To Start the index of pane from 1.
```
setw -g pane-base-index 1                                                                         
```

## Automatically ReNumber windows
```
set-option -g renumber-windows on                                                                 
```

## Enable visual notification
```
setw -g monitor-activity on                                                                       
```

## KeyBind: Reload ~/.tmux.conf when enter `<C-b>` r Key.
```
bind r source-file ~/.tmux.conf \; display "Reloaded ~/.tmux.conf!!"                              
```

## KeyBind: Setup 'v' to begin selection as in Vim
```
bind-key -T copy-mode-vi v send-keys -X begin-selection                                           
bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"       
```

## KeyBind: Update default binding of `Enter` to also use copy-pipe
```
unbind -T copy-mode-vi Enter                                                                      
bind-key -T copy-mode-vi Enter send -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"   
```

## KeyBind: Keep directory when new window is opened.
```
bind c new-window -c "#{pane_current_path}"                                                       
```

## KeyBind: " (Vertical) with set pane size
```
bind '"' split-window -vc "#{pane_current_path}" -p 25                                            
```

## KeyBind: " (Horizontal)
```
bind % split-window -hc "#{pane_current_path}"                                                    
```

## KeyBind: Like Explore 
```
bind e new-window -c "#{pane_current_path}" "vim ."                                               
```

## Status: Set the refresh interval: 1sec (default: 15sec)
```
set -g status-interval 1                                                                          
```

## Status: Display status line: top
```
set -g status-position top                                                                        
```

## Status: line format: other current
```
set -g window-status-format "[#I]#h:#(basename #{pane_current_path})#F"                           
```

## Status: line format: current
```
set -g window-status-current-format "[#I]#h:#(basename #{pane_current_path})#F"                   
```

## Statusr: line right length 
```
set-option -g status-right-length 150                                                             
```

## Status: line format: right 
```
set-option -g status-right "#(loadavg) | #h | #(localip) | %m/%d %H:%M:%S#[default]"              
```

## Color: To correspond to 256 colors.
```
set -g default-terminal "xterm-256color"                                                          
set -g terminal-overrides "term:colors=256"                                                       
```

## Solarized: See also https://github.com/seebi/tmux-colors-solarized/blob/master/tmuxcolors-256.conf 
```
#### COLOUR (Solarized 256)

# default statusbar colors
set-option -g status-bg colour235 #base02
set-option -g status-fg colour136 #yellow
set-option -g status-attr default

# default window title colors
set-window-option -g window-status-fg colour244 #base0
set-window-option -g window-status-bg default
#set-window-option -g window-status-attr dim

# active window title colors
set-window-option -g window-status-current-fg colour166 #orange
set-window-option -g window-status-current-bg default
#set-window-option -g window-status-current-attr bright

# pane border
#set-option -g pane-border-fg colour235 #base02
set-option -g pane-border-fg colour240 #base02
set-option -g pane-active-border-fg colour240 #base01

# message text
set-option -g message-bg colour235 #base02
set-option -g message-fg colour166 #orange

# pane number display
set-option -g display-panes-active-colour colour33 #blue
set-option -g display-panes-colour colour166 #orange

# clock
set-window-option -g clock-mode-colour colour64 #green

# bell
set-window-option -g window-status-bell-style fg=colour235,bg=colour160 #base02, red
```

