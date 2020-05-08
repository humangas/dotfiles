# dotfiles
[![OS macOS](https://img.shields.io/badge/OS-macOS-blue.svg)](OS)
[![Build Status](https://travis-ci.org/humangas/dotfiles.svg?branch=master)](https://travis-ci.org/humangas/dotfiles)  

humangas's macOS setup tool



## Installation
```
$ curl -sL https://raw.githubusercontent.com/humangas/dotfiles/master/install | bash
```


### Specify roles to install 
With the settings below you can specify the roles to install (# is a comment).

```
# Get roles list
$ curl -sL https://raw.githubusercontent.com/humangas/dotfiles/master/list | bash > roles.lst

# Update roles list
$ vim roles.lst
ag
# vim
zsh

# Set roles list to DOTF_ROLES_LIST environment
$ export DOTF_ROLES_LIST=roles.lst
```


### NOTE: sudo password
If you make the following settings in advance, you will not be asked for sudo password.

```
$ sudo sh -c "echo `whoami` ALL=\(ALL\) NOPASSWD:ALL > /private/etc/sudoers.d/`whoami`"
```

Delete it if it is not necessary after the installation is completed.

```
$ sudo rm -f /private/etc/sudoers.d/$(whoami)
```



## For local
```
$ git clone https://github.com/humangas/dotfiles.git
$ cd dotfiles
$ make install
```


### Usage
```
$ dotf --help
Usage: dotf <command> [option] [<role>]

Command:
    list                    List roles
    version   <role>        Version <role>
    install   <role>        Install <role>
    upgrade   <role>        Upgrade <role>
    validate  <role>        Validate <role>
    new       <role>        Create new [option] <role>

Option:
    --type    <type>        "<type>" specifies "main.sh.<type>" under roles/_templates directory
                            Default: "$DOTF_NEW_TYPE_DEFAULT"
                            Only "new" command option

Settings:
    export EDITOR="vim"
    export DOTF_NEW_TYPE_DEFAULT="plain"

Examples:
    dotf list
    dotf version go
    dotf install go
    dotf upgrade go
    dotf validate go
    dotf new go
    dotf new --type brew go

```

