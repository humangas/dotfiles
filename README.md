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
```

Delete it if it is not necessary after the installation is completed.
```
$ sudo rm -f /private/etc/sudoers.d/$(whoami)
```

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


## For local
```
$ git clone https://github.com/humangas/dotfiles.git
$ cd dotfiles
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
