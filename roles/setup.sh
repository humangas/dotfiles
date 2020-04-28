#!/bin/bash

usage() {
cat << EOS 
Usage: $(basename $0) <command> [option] [<args>]...

Command:
    list      [role]...         List [role]... 
    versions  [role]...         List version of [role]...
    install   [role]...         Install [role]...
    upgrade   [role]...         Upgrade [role]...
    config    [role]...         Configure [role]...
    create    <role>...         Create <role>...
    edit      [role]            Edit "setup.sh" of <role> with \$EDITOR (Default: roles/setup.sh)

Option:
    --type    <type>            "<type>" specifies "setup.sh.<type>" under _templates directory
                                Default: "\$SETUP_TYPE_DEFAULT"
                                Only "create" command option

Settings:
    export EDITOR="vim"
    export SETUP_TYPE_DEFAULT="setup.sh.brew"
    export SETUP_LIST_FILES_DEPTH=3

Examples:
    $(basename $0) install
    $(basename $0) install brew go direnv
    $(basename $0) create --type brewcask vagrant clipy skitch
    $(basename $0) edit ansible

Convenient usage:
    # List only roles that contain files
    $ setup list | awk '\$10!="-"{print \$1" "\$10}' | column -t

EOS
exit 1
}

# Settings
SETUP_TYPE_DEFAULT="${SETUP_TYPE_DEFAULT:-setup.sh.brew}"
SETUP_LIST_FILES_DEPTH="${SETUP_LIST_FILES_DEPTH:-3}"
SETUP_TRUE_MARK="✓"
SETUP_FALSE_MARK="✗"

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

execute() {
    SETUP_SHELL_NAME="${SHELL##*/}"

    _execute() {
        local role_setup_path="${1:?Error \"role_setup_path\" is required}"
        local func="${2:?Error \"func\" is required}"
        local is_depend="${3:-0}"

        source "$role_setup_path"

        if ! is_installed; then
            [[ $is_depend -eq 1 ]] && log "INFO" "====> install dependency: $SETUP_CURRENT_ROLE_NAME..."
            install
            [[ $? -ne 0 ]] && log "ERROR" "Error: occurred during \"$SETUP_CURRENT_ROLE_NAME\" \"install\"" && exit 1
        fi

        case "$func" in
            install) # do nothing
                ;;
            *)  # [upgrade|config]
                "$func" 
                [[ $? -ne 0 ]] && log "ERROR" "Error: occurred during \"$SETUP_CURRENT_ROLE_NAME\" \"$func\"" && exit 1
                ;;
        esac

        unset -f is_installed
        unset -f install
        unset -f "$func"
    }

    depend() {
        # This function is called inside setup.sh of each role.
        # Examples: depend "install" "brew"
        local func="${1:?Error \"func\" is required}"
        local role="${2:?Error \"role\" is required}"
        # local caller="$SETUP_CURRENT_ROLE_FILE_PATH"
        local caller="${BASH_SOURCE[1]}"

        SETUP_CURRENT_ROLE_NAME="$role"
        SETUP_CURRENT_ROLE_DIR_PATH="$SETUP_ROLES_PATH/$role"
        _execute "$SETUP_CURRENT_ROLE_DIR_PATH/setup.sh" "$func" "1"

        SETUP_CURRENT_ROLE_DIR_PATH="${caller%/*}"
        SETUP_CURRENT_ROLE_NAME="${SETUP_CURRENT_ROLE_DIR_PATH##*/}"
        source "$caller"
    }

    # [install|upgrade|config]
    declare -a roles=()
    for SETUP_CURRENT_ROLE_FILE_PATH in $(find "$SETUP_ROLES_PATH"/*/* -type f -name "setup.sh"); do
        SETUP_CURRENT_ROLE_DIR_PATH="${SETUP_CURRENT_ROLE_FILE_PATH%/*}"
        SETUP_CURRENT_ROLE_NAME="${SETUP_CURRENT_ROLE_DIR_PATH##*/}"
        roles+=( $SETUP_CURRENT_ROLE_NAME )
        if [[ $# -eq 0 ]] || in_elements "$SETUP_CURRENT_ROLE_NAME" "$@"; then
            log "INFO" "==> $SETUP_FUNC_NAME $SETUP_CURRENT_ROLE_NAME..."
            _execute "$SETUP_CURRENT_ROLE_FILE_PATH" "$SETUP_FUNC_NAME"
        fi
    done

    # Check role name specified by the parameter
    for t in "$@"; do 
        if ! in_elements "$t" "${roles[@]}"; then
            log "INFO" "==> $SETUP_FUNC_NAME $t..."
            log "ERROR" "Error: \"$t\" role is not found"
        fi
    done
}

versions() {
    # Print header
    printf "role,version\n"
    declare -a roles=()
    for SETUP_CURRENT_ROLE_FILE_PATH in $(find "$SETUP_ROLES_PATH"/*/* -type f -name "setup.sh"); do
        SETUP_CURRENT_ROLE_DIR_PATH="${SETUP_CURRENT_ROLE_FILE_PATH%/*}"
        SETUP_CURRENT_ROLE_NAME="${SETUP_CURRENT_ROLE_DIR_PATH##*/}"
        roles+=( $SETUP_CURRENT_ROLE_NAME )
        if [[ $# -eq 0 ]] || in_elements "$SETUP_CURRENT_ROLE_NAME" "$@"; then
            source "$SETUP_CURRENT_ROLE_FILE_PATH"
            local _version=$(version 2>/dev/null | head -n1 | sed -e s/,/_/g)
            printf "$SETUP_CURRENT_ROLE_NAME,$_version\n"
            unset -f version
        fi
    done

    # Check role name specified by the parameter
    for t in "$@"; do 
        if ! in_elements "$t" "${roles[@]}"; then
            # Not installed
            printf "$t,Error,Error\n"
        fi
    done
}

list() {
    # Print header
    printf "role,README,is_installed,config,version,install,upgrade,files\n"

    local role _is_installed _config _version _install _upgrade
    for SETUP_CURRENT_ROLE_FILE_PATH in $(find "$SETUP_ROLES_PATH"/*/* -type f -name "setup.sh"); do
        SETUP_CURRENT_ROLE_DIR_PATH="${SETUP_CURRENT_ROLE_FILE_PATH%/*}"
        SETUP_CURRENT_ROLE_NAME="${SETUP_CURRENT_ROLE_DIR_PATH##*/}"

        if [[ $# -gt 0 ]] && ! in_elements "$SETUP_CURRENT_ROLE_NAME" "$@"; then
            continue
        fi

        source "$SETUP_CURRENT_ROLE_FILE_PATH"
        [[ $(type -t is_installed) == "function" ]] && _is_installed="$SETUP_TRUE_MARK" || _is_installed="$SETUP_FALSE_MARK"
        [[ $(type -t config) == "function" ]] && _config="$SETUP_TRUE_MARK" || _config="$SETUP_FALSE_MARK"
        [[ $(type -t version) == "function" ]] && _version="$SETUP_TRUE_MARK" || _version="$SETUP_FALSE_MARK"
        [[ $(type -t install) == "function" ]] && _install="$SETUP_TRUE_MARK" || _install="$SETUP_FALSE_MARK"
        [[ $(type -t upgrade) == "function" ]] && _upgrade="$SETUP_TRUE_MARK" || _upgrade="$SETUP_FALSE_MARK"
        _readme=$([[ -f "$SETUP_CURRENT_ROLE_DIR_PATH/README.md" ]] && echo "$SETUP_TRUE_MARK" || echo "$SETUP_FALSE_MARK")
        _files=$(find $SETUP_CURRENT_ROLE_DIR_PATH -maxdepth $SETUP_LIST_FILES_DEPTH -type f \
                    | /usr/bin/egrep -v "_template|setup\.sh|README\.md\..*" \
                    | sed "s@$SETUP_CURRENT_ROLE_DIR_PATH/@@" \
                    | paste -s -d '|' -)
        _files=${_files:-"-"}

        printf "$SETUP_CURRENT_ROLE_NAME,$_readme,$_is_installed,$_config,$_version,$_install,$_upgrade,$_files\n"

        unset -f is_installed
        unset -f config
        unset -f version
        unset -f install
        unset -f upgrade
    done
}

_check() {
    # It checks the implementation status of functions of each role, and terminates processing if not implemented.
    local is_err=0

    _errmsg() {
        log "ERROR" "Error: \"$1\" function is not implemented in \"$2\" role"
        is_err=1
    }

    for SETUP_CURRENT_ROLE_FILE_PATH in $(find "$SETUP_ROLES_PATH"/*/* -type f -name "setup.sh"); do
        SETUP_CURRENT_ROLE_DIR_PATH="${SETUP_CURRENT_ROLE_FILE_PATH%/*}"
        SETUP_CURRENT_ROLE_NAME="${SETUP_CURRENT_ROLE_DIR_PATH##*/}"

        if [[ $# -gt 0 ]] && ! in_elements "$SETUP_CURRENT_ROLE_NAME" "$@"; then
            continue
        fi

        source "$SETUP_CURRENT_ROLE_FILE_PATH"
        [[ $(type -t is_installed) == "function" ]] || _errmsg "is_installed" "$SETUP_CURRENT_ROLE_NAME"
        [[ $(type -t config) == "function" ]]  || _errmsg "config" "$SETUP_CURRENT_ROLE_NAME"
        [[ $(type -t version) == "function" ]]  || _errmsg "version" "$SETUP_CURRENT_ROLE_NAME"
        [[ $(type -t install) == "function" ]] || _errmsg "install" "$SETUP_CURRENT_ROLE_NAME"
        [[ $(type -t upgrade) == "function" ]] || _errmsg "upgrade" "$SETUP_CURRENT_ROLE_NAME"

        unset -f is_installed
        unset -f config
        unset -f version
        unset -f install
        unset -f upgrade
    done
    
    [[ $is_err -eq 0 ]] || exit 1
}

create() {
    if [[ ! -f "$SETUP_ROLES_PATH/_templates/$SETUP_CREATE_TYPE" ]]; then
        log "ERROR" "Error: \"$SETUP_CREATE_TYPE\" is not found under _templates directory"
        exit 1
    fi

    for r in $@; do
        if [[ ! -e "$SETUP_ROLES_PATH/$r" ]]; then
            mkdir -p "$SETUP_ROLES_PATH/$r"
            cp "$SETUP_ROLES_PATH/_templates/$SETUP_CREATE_TYPE" "$SETUP_ROLES_PATH/$r/${SETUP_CREATE_TYPE%.*}"
            echo -e "# $r\nTODO: Please write the contents" > "$SETUP_ROLES_PATH/$r/README.md"
            log "INFO" "==> Created \"$r\" role"
        else
            log "ERROR" "Error: \"$r\" role is already exists"
        fi
    done
}

edit() {
    local editor="${EDITOR:-vim}"
    local setupsh="$SETUP_ROLES_PATH/$SETUP_ROLES/setup.sh"

    if [[ -f "$setupsh" ]]; then
        log "INFO" "Edit $setupsh..."
        "$EDITOR" "$setupsh"
    else
        log "ERROR" "Error: \"$setupsh\" is not found"
        exit 1
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
                        SETUP_CREATE_TYPE="setup.sh.$1"
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
        [[ -z "$SETUP_CREATE_TYPE" ]] && SETUP_CREATE_TYPE="$SETUP_TYPE_DEFAULT"
        [[ -z "$SETUP_ROLES" ]] && usage
    }

    [[ $# -eq 0 ]] && usage
    case "$1" in
        create)     SETUP_FUNC_NAME="create"   ; shift; _parse_create "$@" ;;
        edit)       SETUP_FUNC_NAME="edit"     ; shift; _parse "$@" ;;
        versions)   SETUP_FUNC_NAME="version"  ; shift; _parse "$@" ;;
        list)       SETUP_FUNC_NAME="list"     ; shift; _parse "$@" ;;
        install)    SETUP_FUNC_NAME="install"  ; shift; _parse "$@" ;;
        upgrade)    SETUP_FUNC_NAME="upgrade"  ; shift; _parse "$@" ;;
        config)     SETUP_FUNC_NAME="config"   ; shift; _parse "$@" ;;
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
        create)
            create ${SETUP_ROLES[@]} ;;
        edit)
            edit $SETUP_ROLES ;;
        version) 
            versions ${SETUP_ROLES[@]} | column -ts, ;;
        list)
            list ${SETUP_ROLES[@]} | column -ts, | sed "s/|/,/g" ;;
        *) # [install|upgrade|config]
            declare -a SETUP_CAVEATS_MSGS=()
            _check ${SETUP_ROLES[@]}
#            sudov
            execute ${SETUP_ROLES[@]}
            _print_caveats
            ;;
    esac
}

main "$@"
