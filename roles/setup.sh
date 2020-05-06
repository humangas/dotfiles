#!/usr/bin/env bash -eu

# Settings
DOTF_SETUP_SCRIPT="setup.sh"
DOTF_NEW_TYPE_DEFAULT="${DOTF_NEW_TYPE_DEFAULT:-plain}"
DOTF_NEW_TEMPLATE="$DOTF_SETUP_SCRIPT.$DOTF_NEW_TYPE_DEFAULT"
DOTF_TRUE_MARK="✓"
DOTF_FALSE_MARK="✗"

_usage() {
cat << EOS 
Usage: $(basename $0) <command> [option] [<role>]

Command:
    list                    List roles
    version   <role>        Version <role>
    install   <role>        Install <role>
    upgrade   <role>        Upgrade <role>
    validate  <role>        Validate <role>
    new       <role>        Create new [option] <role>

Option:
    --type    <type>        "<type>" specifies "$DOTF_SETUP_SCRIPT.<type>" under roles/_templates directory
                            Default: "\$DOTF_NEW_TYPE_DEFAULT"
                            Only "new" command option

Settings:
    export EDITOR="vim"
    export DOTF_NEW_TYPE_DEFAULT="$DOTF_NEW_TYPE_DEFAULT"

Examples:
    $(basename $0) list
    $(basename $0) version go
    $(basename $0) install go
    $(basename $0) upgrade go
    $(basename $0) validate go
    $(basename $0) new go
    $(basename $0) new --type brew go

EOS
exit 1
}

abs_dirname() {
    local cwd="$(pwd)"
    local path="$1"

    [[ $path == $(basename $path) ]] && pwd -P && return

    while [ -n "$path" ]; do
        cd "${path%/*}"
        local name="${path##*/}"
        path="$(readlink "$name" || true)"
    done
  
    pwd -P
    cd "$cwd"
}

log() {
    # Examples: log "INFO" "info message"
    local type="${1:?Error: type is required}"
    local msg="${2:?Error: msg is required}"

    case "$type" in
        INFO)   printf "\e[34m$msg\e[m\n" ;;
        WARN)   printf "\e[35m$msg\e[m\n" ;;
        ERROR)  printf "\e[31m$msg\e[m\n" ;;
        *)      printf "\e[31mFatal: \"$type\" is an undefined type. Please implement it in the \"log\" function.\e[m\n"
                exit 1
                ;;
    esac
}

depend() {
    # This function is called inside main.sh of each role (e.g. depend install brew).
    local func="${1:?Error \"func\" is required}"
    local role="${2:?Error \"role\" is required}"
    local caller="${BASH_SOURCE[1]}"

    log "INFO" "==> $func dependencies $role..."
    execute "$DOTF_BASE_PATH/$role/$DOTF_SETUP_SCRIPT" "$func"

    source "$caller"
}

execute() {
    local role_setup_path="${1:?Error \"role_setup_path\" is required}"
    local func="${2:?Error \"func\" is required}"

    [ -e "$role_setup_path" ] || {
        log "ERROR" "Error: \"$role_setup_path\" is not found"
        exit 1
    }

    source "$role_setup_path"
    (cd `dirname "$role_setup_path"`; "$func")

    [[ $? -ne 0 ]] && {
        log "ERROR" "Error: occurred during \"$SETUP_CURRENT_ROLE_NAME\" \"$func\""
        exit 1
    }

    unset -f "$func"
}

install() {
    local role="$1"
    local role_dir="$DOTF_BASE_PATH/$role"
    local script_path="$role_dir/$DOTF_SETUP_SCRIPT"

    _validate "$role" | grep "install:$DOTF_TRUE_MARK" > /dev/null 2>&1 || {
        log "ERROR" "Error: Not implemented"
        return 1
    }

    log "INFO" "==> install $role..."
    execute "$script_path" install
}

upgrade() {
    local role="$1"
    local role_dir="$DOTF_BASE_PATH/$role"
    local script_path="$role_dir/$DOTF_SETUP_SCRIPT"

    _validate "$role" | grep "upgrade:$DOTF_TRUE_MARK" > /dev/null 2>&1 || {
        log "ERROR" "Error: Not implemented"
        return 1
    }

    log "INFO" "==> upgrade $role..."
    execute "$script_path" upgrade
}

_version() {
    local role="$1"
    local script_path="$DOTF_BASE_PATH/$role/$DOTF_SETUP_SCRIPT"

    _validate "$role" | grep "version:$DOTF_TRUE_MARK" > /dev/null 2>&1 || {
        log "ERROR" "Error: Not implemented"
        return 1
    }

    if [ -e "$script_path" ]; then
        source "$script_path"
        local __version=$(version 2>/dev/null | head -n1 | sed -e s/,/_/g)
        printf "$__version\n"
        unset -f version
    else
        printf "$role is not found.\n"
    fi
}

_list() {
    local role_file_path role_dir_path role_name

    for role_file_path in $(find "$DOTF_BASE_PATH/" -type f -name "$DOTF_SETUP_SCRIPT"); do
        role_dir_path="${role_file_path%/*}"
        role_name="${role_dir_path##*/}"
        printf "$role_name\n"
    done
}

_validate() {
    local role="$1"
    local script_path="$DOTF_BASE_PATH/$role/$DOTF_SETUP_SCRIPT"
    local _install _upgrade __version _readme

    if [ -e "$script_path" ]; then
        source "$script_path"

        _readme=$([[ -f "$DOTF_BASE_PATH/$role/README.md" ]] && echo "$DOTF_TRUE_MARK" || echo "$DOTF_FALSE_MARK")
        [[ $(type -t install) == "function" ]] && _install="$DOTF_TRUE_MARK" || _install="$DOTF_FALSE_MARK"
        [[ $(type -t upgrade) == "function" ]] && _upgrade="$DOTF_TRUE_MARK" || _upgrade="$DOTF_FALSE_MARK"
        [[ $(type -t version) == "function" ]] && __version="$DOTF_TRUE_MARK" || __version="$DOTF_FALSE_MARK"

        printf "README:$_readme "
        printf "install:$_install "
        printf "upgrade:$_upgrade "
        printf "version:$__version "
        printf "\n"

        unset -f install
        unset -f upgrade
        unset -f version
    else
        printf "$role is not found.\n"
    fi
}

new() {
    local role="$DOTF_ROLE"
    local template_dir="$DOTF_BASE_PATH/_templates"
    local template_setup_script_path="$template_dir/$DOTF_NEW_TEMPLATE"

    if [[ ! -f "$template_setup_script_path" ]]; then
        log "ERROR" "Error: \"$DOTF_NEW_TEMPLATE\" is not found under _templates directory"
        return 1
    fi

    if [[ ! -e "$DOTF_BASE_PATH/$role" ]]; then
        mkdir -p "$DOTF_BASE_PATH/$role"
        cp "$template_setup_script_path" "$DOTF_BASE_PATH/$role/${DOTF_NEW_TEMPLATE%.*}"
        cp "$template_dir/README.md" "$DOTF_BASE_PATH/$role"
        sed -i "s/\${role}/$role/g" "$DOTF_BASE_PATH/$role/README.md"
        log "INFO" "==> Created \"$role\" role"
    else
        log "ERROR" "Error: \"$role\" role is already exists"
        return 1
    fi
}

_parse_new() {
    local is_parsed=0
    while getopts ":-:" opt; do
        case "$opt" in
            -)  # long option
            case "${OPTARG}" in
                type) 
                    is_parsed=1
                    shift $((OPTIND -1))
                    DOTF_NEW_TEMPLATE="$DOTF_SETUP_SCRIPT.$1"
                    ;;
                *)  _usage ;;
            esac
            ;;
            *)  _usage ;;
        esac
    done
    [ $is_parsed -eq 0 ] && DOTF_ROLE="$1" || shift; DOTF_ROLE="$1"
}

main() {
    DOTF_BASE_PATH=$(abs_dirname $0)

    [ $# -eq 0 ] && _usage
    local func="$1"
    shift

    case "$func" in
        new)       _parse_new "$@"; new ;;
        list)      _list "$@" ;;
        install)   install "$@" ;;
        upgrade)   upgrade "$@" ;;
        version)   _version "$@" ;;
        validate)  _validate "$@" ;;
        *)         _usage ;;
    esac
}

main "$@"

