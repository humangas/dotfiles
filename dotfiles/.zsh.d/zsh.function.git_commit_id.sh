#!/usr/bin/env zsh

alias gci='fcs'

# fcs - get git commit sha
# example usage: git rebase -i `fcs`, git checkout `fcs` <file_pat>
# See also: https://github.com/junegunn/fzf/wiki/examples
fcs() {
    local commits commit
    commits=$(git log --color=always --pretty=oneline --abbrev-commit --reverse) &&
    commit=$(echo "$commits" | fzf --tac +s +m -e --ansi --reverse) &&
    echo -n $(echo "$commit" | sed "s/ .*//")
}
