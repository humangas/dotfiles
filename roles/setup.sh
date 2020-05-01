#!/usr/bin/env bash -eu

# Settings
DOTF_SETUP_SCRIPT="setup.sh"
DOTF_NEW_TYPE_DEFAULT="${DOTF_NEW_TYPE_DEFAULT:-plain}"
SETUP_LIST_FILES_DEPTH="${SETUP_LIST_FILES_DEPTH:-3}"
SETUP_TRUE_MARK="✓"
SETUP_FALSE_MARK="✗"

usage() {
cat << EOS 
Usage: $(basename $0) <command> [option] [<args>]...

Command:
    list                        List roles
    version   <role>...         Version <role>...
    install   [role]...         Install [role]...
    upgrade   [role]...         Upgrade [role]...
    config    [role]...         Configure [role]...
    new       <role>            Create new [option] <role>
    validate  <role>            Validate <role>

Option:
    --type    <type>            "<type>" specifies "$DOTF_SETUP_SCRIPT.<type>" under roles/_templates directory
                                Default: "\$DOTF_NEW_TYPE_DEFAULT"
                                Only "new" command option

Settings:
    export EDITOR="vim"
    export DOTF_NEW_TYPE_DEFAULT="$DOTF_NEW_TYPE_DEFAULT"
    export SETUP_LIST_FILES_DEPTH=3

Examples:
    $(basename $0) install
    $(basename $0) install go
    $(basename $0) create python
    $(basename $0) create --type brewcask java

Convenient usage:
    # List only roles that contain files
    $ setup list | awk '\$10!="-"{print \$1" "\$10}' | column -t

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

in_elements () {
    local e match="$1"
    shift
    for e; do [[ "$e" == "$match" ]] && return 0; done
    return 1
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

caveats() {
    # Examples: caveats "INFO" "info message"
    # It will be displayed at the end after installation
    local type="${1:?Error: type is required}"
    local msg="${2:?Error: msg is required}"
    local caveats

    case "$type" in
        INFO)   caveats="\e[34m$msg\e[m\n" ;;
        WARN)   caveats="\e[35m$msg\e[m\n" ;;
        ERROR)  caveats="\e[31m$msg\e[m\n" ;;
        *)      printf "\e[31mFatal: \"$type\" is an undefined type. Please implement it in the \"log\" function.\e[m\n"
                exit 1
                ;;
    esac

    SETUP_CAVEATS_MSGS=("${SETUP_CAVEATS_MSGS[@]}" "$caveats")
}

_print_caveats() {
    [[ ${#SETUP_CAVEATS_MSGS[@]} -gt 0 ]] && log "WARN" "\nCaveats:"
    for ((i = 0; i < ${#SETUP_CAVEATS_MSGS[@]}; i++)) {
        printf "${SETUP_CAVEATS_MSGS[i]}"
    }
}

depend() {
    # This function is called inside main.sh of each role (e.g. depend install brew).
    local func="${1:?Error \"func\" is required}"
    local role="${2:?Error \"role\" is required}"
    local caller="${BASH_SOURCE[1]}"

    # SETUP_CURRENT_ROLE_DIR_PATH="$SETUP_ROLES_PATH/$role"
    log "INFO" "==> $func dependencies $role..."
    # execute "$SETUP_CURRENT_ROLE_DIR_PATH/$DOTF_SETUP_SCRIPT" "$func"
    execute "$SETUP_ROLES_PATH/$role/$DOTF_SETUP_SCRIPT" "$func"

    # SETUP_CURRENT_ROLE_DIR_PATH="${caller%/*}"
    # SETUP_CURRENT_ROLE_NAME="${SETUP_CURRENT_ROLE_DIR_PATH##*/}"
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
    local role_dir="$SETUP_ROLES_PATH/$role"
    local script_path="$role_dir/$DOTF_SETUP_SCRIPT"

    validate "$role" | grep "install:$SETUP_TRUE_MARK" > /dev/null 2>&1 || {
        log "ERROR" "Error: Not implemented"
        return 1
    }

    log "INFO" "==> install $role..."
    execute "$script_path" install
}

version() {
    local role="$1"
    local script_path="$SETUP_ROLES_PATH/$role/$DOTF_SETUP_SCRIPT"

    validate "$role" | grep "version:$SETUP_TRUE_MARK" > /dev/null 2>&1 || {
        log "ERROR" "Error: Not implemented"
        return 1
    }

    if [ -e "$script_path" ]; then
        source "$script_path"
        local _version=$(version 2>/dev/null | head -n1 | sed -e s/,/_/g)
        printf "$_version\n"
        unset -f version
    else
        printf "$role is not found.\n"
    fi
}

list() {
    local role_file_path role_dir_path role_name

    for role_file_path in $(find "$SETUP_ROLES_PATH/" -type f -name "$DOTF_SETUP_SCRIPT"); do
        role_dir_path="${role_file_path%/*}"
        role_name="${role_dir_path##*/}"
        printf "$role_name\n"
    done
}

validate() {
    local role="$1"
    local script_path="$SETUP_ROLES_PATH/$role/$DOTF_SETUP_SCRIPT"
    local _install _upgrade _version _readme

    if [ -e "$script_path" ]; then
        source "$script_path"

        _readme=$([[ -f "$SETUP_ROLES_PATH/$role/README.md" ]] && echo "$SETUP_TRUE_MARK" || echo "$SETUP_FALSE_MARK")
        [[ $(type -t install) == "function" ]] && _install="$SETUP_TRUE_MARK" || _install="$SETUP_FALSE_MARK"
        [[ $(type -t upgrade) == "function" ]] && _upgrade="$SETUP_TRUE_MARK" || _upgrade="$SETUP_FALSE_MARK"
        [[ $(type -t version) == "function" ]] && _version="$SETUP_TRUE_MARK" || _version="$SETUP_FALSE_MARK"

        printf "README:$_readme "
        printf "install:$_install "
        printf "upgrade:$_upgrade "
        printf "version:$_version "
        printf "\n"

        unset -f install
        unset -f upgrade
        unset -f version
    else
        printf "$role is not found.\n"
    fi
}

new() {
    local role="$1"
    local template_dir="$SETUP_ROLES_PATH/_templates"
    local template_setup_script_path="$template_dir/$SETUP_CREATE_TYPE"

    if [[ ! -f "$template_setup_script_path" ]]; then
        log "ERROR" "Error: \"$SETUP_CREATE_TYPE\" is not found under _templates directory"
        return 1
    fi

    if [[ ! -e "$SETUP_ROLES_PATH/$role" ]]; then
        mkdir -p "$SETUP_ROLES_PATH/$role"
        cp "$template_setup_script_path" "$SETUP_ROLES_PATH/$role/${SETUP_CREATE_TYPE%.*}"
        cp "$template_dir/README.md" "$SETUP_ROLES_PATH/$role"
        sed -i "s/\${role}/$role/g" "$SETUP_ROLES_PATH/$role/README.md"
        log "INFO" "==> Created \"$role\" role"
    else
        log "ERROR" "Error: \"$role\" role is already exists"
        return 1
    fi
}

_options() {
    _parse() {
        local is_parsed=0
        while getopts ":-:" opt; do
            case "$opt" in
                -)  # long option
                case "${OPTARG}" in
                    type) 
                        is_parsed=1
                        shift $((OPTIND -1))
                        SETUP_CREATE_TYPE="$DOTF_SETUP_SCRIPT.$1"
                        ;;
                    *)  usage ;;
                esac
                ;;
                *)  usage ;;
            esac
        done
        [[ "$is_parsed" -eq 0 ]] && SETUP_ROLES="$@" || shift; SETUP_ROLES="$@"
    }

    _parse_create() {
        _parse "$@"
        [[ -z "$SETUP_CREATE_TYPE" ]] && SETUP_CREATE_TYPE="$DOTF_SETUP_SCRIPT.$DOTF_NEW_TYPE_DEFAULT"
        [[ -z "$SETUP_ROLES" ]] && usage
    }

    [[ $# -eq 0 ]] && usage
    case "$1" in
        new)        SETUP_FUNC_NAME="new"      ; shift; _parse_create "$@" ;;
        version)    SETUP_FUNC_NAME="version"  ; shift; _parse "$@" ;;
        list)       SETUP_FUNC_NAME="list"     ; shift; _parse "$@" ;;
        install)    SETUP_FUNC_NAME="install"  ; shift; _parse "$@" ;;
        upgrade)    SETUP_FUNC_NAME="upgrade"  ; shift; _parse "$@" ;;
        config)     SETUP_FUNC_NAME="config"   ; shift; _parse "$@" ;;
        validate)   SETUP_FUNC_NAME="validate" ; shift; _parse "$@" ;;
        *)          usage ;;
    esac
}

sudov() {
    # NOTE: Even the following will ask you for the password, so i decided to respond with sudoers.
    # See also: https://github.com/humangas/dotfiles/blob/master/README.md#note
    # See also: https://github.com/caskroom/homebrew-cask/issues/19180
    [[ -z "$SETUP_SUDO_PASSWORD" ]] && sudo -v || sudo -S -v <<< "$SETUP_SUDO_PASSWORD" 2>/dev/null
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
}

main() {
    SETUP_ROLES_PATH=$(abs_dirname $0)
    _options "$@"
    case "$SETUP_FUNC_NAME" in
        validate)
            validate ${SETUP_ROLES[@]} ;;
        new)
            new ${SETUP_ROLES[@]} ;;
        version) 
            version ${SETUP_ROLES[@]} ;;
        list)
            list ${SETUP_ROLES[@]} ;;
        install) install ${SETUP_ROLES[@]} ;;

        *) # [install|upgrade|config]
            declare -a SETUP_CAVEATS_MSGS=()
#            sudov
            execute ${SETUP_ROLES[@]}
            _print_caveats
            ;;
    esac
}

main "$@"
