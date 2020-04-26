# dotfiles
[![OS macOS](https://img.shields.io/badge/OS-macOS-blue.svg)](OS)
[![Build Status](https://travis-ci.org/humangas/dotfiles.svg?branch=master)](https://travis-ci.org/humangas/dotfiles)  

My macOS setup tool and dotfiles  
See also: https://humangas.github.io/dotfiles/


## Installation
```
$ curl -sL https://raw.githubusercontent.com/humangas/dotfiles/master/install | bash
```


### Setting computer name
You can set the your computer name by setting environment variables as follows.

```
$ export SETUP_COMPUTER_NAME="<your computer name>"
```

### Specify roles to install 
With the settings below you can specify the roles to install (# is a comment).

#### Roles
```
$ export SETUP_ROLES_LIST=roles.lst
$ cat roles.lst
zsh
vim
# curl
tmux
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
    versions  [role]...         List version of [role]...
    install   [role]...         Install [role]...
    upgrade   [role]...         Upgrade [role]...
    config    [role]...         Configure [role]...
    enable    [role]...         Enable [role]...
    disable   [role]...         Disable [role]...
    create    <role>...         Create <role>...
    edit      [role]            Edit "setup.sh" of <role> with $EDITOR (Default: roles/setup.sh)

Option:
    --type    <type>            "<type>" specifies "setup.sh.<type>" under _templates directory
                                Default: "$SETUP_TYPE_DEFAULT"
                                Only "create" command option

Settings:
    export EDITOR="vim"
    export SETUP_TYPE_DEFAULT="setup.sh.brew"
    export SETUP_LIST_FILES_DEPTH=3

Examples:
    setup install
    setup install brew go direnv
    setup create --type brewcask vagrant clipy skitch
    setup edit ansible

Convenient usage:
    # List only roles that contain files
    $ setup list | awk '$10!="-"{print $1" "$10}' | column -t

```

