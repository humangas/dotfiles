# dotfiles
My macOS setup tool and dotfiles


## Installation
```
$ curl -sL https://raw.githubusercontent.com/humangas/dotfiles/master/install | bash
```

### NOTE
If you make the following settings in advance, you will not be asked for sudo password.
```
$ sudo sh -c "echo `whoami` ALL=\(ALL\) NOPASSWD:ALL > /private/etc/sudoers.d/`whoami`"
$ cat /private/etc/sudoers.d/$(whoami)
humangas ALL=(ALL) NOPASSWD:ALL
```

Delete it if it is not necessary after the installation is completed.
```
$ sudo rm -f /private/etc/sudoers.d/$(whoami)
```


## Setup of this tool itself
Prepare the ssh secret key for github.com

```
$ ssh-add ~/.ssh/github.pem
```

Git clone this repository
```
$ git clone git@github.com:humangas/dotfiles.git ~/src/github.com/humangas/dotfiles
```
OR
```
$ git config --global ghq.root ~/src
$ ghq get git@github.com:humangas/dotfiles.git
```

Install setup tool
```
$ cd ~/src/github.com/humangas/dotfiles
$ make install
```

### Usage
```
Usage: setup <command> [option] [<roles...>]

Command:
    install  [roles...]   Install roles
    upgrade  [roles...]   Upgrade roles
    config   [roles...]   Configure roles
    version  [roles...]   Display version of roles
    list     [roles...]   List roles (status: enable, disable, None=not installed, Error=not implemented or role not found)
    disable  [roles...]   Disable roles
    enable   [roles...]   Enable roles
    dotfiles [roles...]   Output dofiles to the dotfiles directory (need to implement the "dotfiles" function)
    create   <roles...>   Create the specified role (ok=implemented, -=not implemented)
    check                 Check whether setup.sh for each role implements the required function

Option:
    --clear               Clear "setup.versions" file and reacquire the list (only "list" command)
    --type, -t <type>     "<type>" specifies "setup.sh.<type>" under _templates directory (only "create" command)
                          not specify an option, "setup.sh.default" is selected

Examples:
    setup install
    setup install brew go direnv
    setup create --type brew direnv
    setup check

```
