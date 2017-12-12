# dotfiles
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)
[![OS macOS](https://img.shields.io/badge/OS-macOS-blue.svg)](OS)  
My macOS setup tool and dotfiles


## Installation
```
$ curl -sL https://raw.githubusercontent.com/humangas/dotfiles/master/install | bash
```

### Setting
With the settings below you can specify the roles and tags to install (# is a comment).

#### Roles
```
$ export SETUP_ROLES_LIST=roles.lst
$ cat roles.lst
zsh
vim
# curl
tmux
```

#### Tags
```
$ export SETUP_TAGS_LIST=tags.lst
$ cat tags.lst
GNU_commands
Git
Python
```

### NOTE
### sudo password
If you make the following settings in advance, you will not be asked for sudo password.
```
$ sudo sh -c "echo `whoami` ALL=\(ALL\) NOPASSWD:ALL > /private/etc/sudoers.d/`whoami`"
```

Delete it if it is not necessary after the installation is completed.
```
$ sudo rm -f /private/etc/sudoers.d/$(whoami)
```

### GateKeeper
If you install GateKeeper non-compatible application, execute the following command.
```
$ sudo spctl --master-disable
```

This is a command to put the following state.
- Security & Privacy > Allow application download from: > Anywhere

Then do the following.
1. Open Security & Privacy > Click Allow button
2. Reinstall application

After installing, execute the following command to enable GateKeeper.
```
$ sudo spctl --master-enable
```


## For Local
```
$ git clone https://github.com/humangas/dotfiles.git
$ cd dotfiles
$ make install
```


### Usage
```
Usage: setup <command> [option] [<args>]...

Command:
    list      [role]...         List [role]... 
    tags      [role]...         List tags and the roles associated with them
    versions  [role]...         List version of [role]...
    install   [role]...         Install [role]...
    upgrade   [role]...         Upgrade [role]...
    config    [role]...         Configure [role]...
    enable    [role]...         Enable [role]...
    disable   [role]...         Disable [role]...
    create    <role>...         Create <role>...
    edit      [role]            Edit "setup.sh" of <role> with $EDITOR (Default: roles/setup.sh)
    tag-add   <tag> [role]...   Add <tag> to [role]... (Default: to all roles)
    tag-del   <tag> [role]...   Delete <tag> to [role]... (Default: to all roles)
    tag-ren   <old> <new>       Rename <old-tag> to <new-tag>

Option:
    --tags    <tag>...          Only process roles containing "$SETUP_TAGS_PREFIX<tag>"
                                Multiple tags can be specified by separating them with a comma(,).
                                Only "[list|tags|versions|install|upgrade|config|enable|disable]" command option
    --type    <type>            "<type>" specifies "setup.sh.<type>" under _templates directory
                                Default: "$SETUP_TYPE_DEFAULT"
                                Only "create" command option

Settings:
    export EDITOR="vim"
    export SETUP_TAGS_PREFIX="tag."
    export SETUP_TYPE_DEFAULT="setup.sh.brew"
    export SETUP_LIST_FILES_DEPTH=3

Examples:
    setup install
    setup install brew go direnv
    setup create --type brewcask vagrant clipy skitch
    setup edit ansible
    setup disable --tags GNU_commands,Quicklook
    setup tags --tags GNU_commands,Quicklook ag
    setup tag-add GNU_commands grep coreutils

Convenient usage:
    # List only roles that contain files
    $ setup list | awk '$10!="-"{print $1" "$10}' | column -t

```


## Docs
Generate a document.

### Setup
use: mkdocs-material
```
$ brew install pyenv pyenv-virtualenv
$ pyenv install 3.6.3
$ pyenv virtualenv 3.6.3 dotfiles
$ pyenv shell dotfiles
$ pip install mkdocs-material
```

### Usage
```
$ make docs
```
