# How to use template
First, create a role with each temmplate.

- e.g. `$ dotf new --type brew make` 
- Default: --type plain


Implement the created main.sh according to the following rules.

Implement the following functions.

- version
- install
- upgrade


The following functions can be used.

- log: e.g. log INFO "messages..."
- depend: e.g. depend install brew

