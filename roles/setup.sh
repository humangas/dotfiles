#!/bin/bash

usage() {
cat << EOS 
Usage: $(basename $0) <command> [option] [<role>...]

Command:
    list                  List roles (status:[enable|disable], implemented:[y(yes)|n(no)])
    install  [role...]    Install [role...]
    upgrade  [role...]    Upgrade [role...]
    config   [role...]    Configure [role...]
    version  [role...]    Display version of [role...] NOTE: Execute with no [role...] takes time
    disable  [role...]    Disable [role...]
    enable   [role...]    Enable [role...]
    create   <role>...    Create <role>...
    edit     <role>       Edit "setup.sh" of <role> with \$EDITOR (default: vim)

Option:
    --type, -t <type>     "<type>" specifies "setup.sh.<type>" under _templates directory (only "create" command)
                          not specify an option, "setup.sh.default" is selected

Examples:
    $(basename $0) install
    $(basename $0) install brew go direnv
    $(basename $0) create --type brewcask vagrant clipy skitch
    $(basename $0) edit ansible

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
    [[ $# -eq 0 ]] && return 0
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
    local caveats=""

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

execute() {
    SETUP_ROLES_PATH=$(abs_dirname $0)
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
        [[ -e "$SETUP_CURRENT_ROLE_DIR_PATH/disable" ]] && continue
        roles+=( $SETUP_CURRENT_ROLE_NAME )
        if in_elements "$SETUP_CURRENT_ROLE_NAME" "$@"; then
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

version() {
    SETUP_ROLES_PATH=$(abs_dirname $0)

    # Print header
    printf "role,status,version\n"
    declare -a roles=()
    for SETUP_CURRENT_ROLE_FILE_PATH in $(find "$SETUP_ROLES_PATH"/*/* -type f -name "setup.sh"); do
        SETUP_CURRENT_ROLE_DIR_PATH="${SETUP_CURRENT_ROLE_FILE_PATH%/*}"
        SETUP_CURRENT_ROLE_NAME="${SETUP_CURRENT_ROLE_DIR_PATH##*/}"
        roles+=( $SETUP_CURRENT_ROLE_NAME )
        if in_elements "$SETUP_CURRENT_ROLE_NAME" "$@"; then
            source "$SETUP_CURRENT_ROLE_FILE_PATH"

            if is_installed; then
                local _status=$([[ -f "$SETUP_CURRENT_ROLE_DIR_PATH/disable" ]] && echo "disable" || echo "enable")
            else
                local _status="None"
            fi
            local _version=$(version 2>/dev/null | head -n1 | sed -e s/,/_/g)

            printf "$SETUP_CURRENT_ROLE_NAME,$_status,$_version\n"

            unset -f is_installed
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
    SETUP_ROLES_PATH=$(abs_dirname $0)

    # Print header
    printf "role,status,is_installed,config,version,install,upgrade\n"
    for SETUP_CURRENT_ROLE_FILE_PATH in $(find "$SETUP_ROLES_PATH"/*/* -type f -name "setup.sh"); do
        SETUP_CURRENT_ROLE_DIR_PATH="${SETUP_CURRENT_ROLE_FILE_PATH%/*}"
        SETUP_CURRENT_ROLE_NAME="${SETUP_CURRENT_ROLE_DIR_PATH##*/}"

        source "$SETUP_CURRENT_ROLE_FILE_PATH"
        [[ $(type -t is_installed) == "function" ]] && _is_installed="y" || _is_installed="n"
        [[ $(type -t config) == "function" ]] && _config="y" || _config="n"
        [[ $(type -t version) == "function" ]] && _version="y" || _version="n"
        [[ $(type -t install) == "function" ]] && _install="y" || _install="n"
        [[ $(type -t upgrade) == "function" ]] && _upgrade="y" || _upgrade="n"
        local _status=$([[ -f "$SETUP_CURRENT_ROLE_DIR_PATH/disable" ]] && echo "disable" || echo "enable")

        printf "$SETUP_CURRENT_ROLE_NAME,$_status,$_is_installed,$_config,$_version,$_install,$_upgrade\n"

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

    # is_installed
    for r in $(list | awk -F, 'NR > 1 && $2~/enable/ && $3!~/y/{print $1}'); do _errmsg "is_installed" "$r"; done
    # config
    for r in $(list | awk -F, 'NR > 1 && $2~/enable/ && $4!~/y/{print $1}'); do _errmsg "config" "$r"; done
    # version
    for r in $(list | awk -F, 'NR > 1 && $2~/enable/ && $5!~/y/{print $1}'); do _errmsg "version" "$r"; done
    # install
    for r in $(list | awk -F, 'NR > 1 && $2~/enable/ && $6!~/y/{print $1}'); do _errmsg "install" "$r"; done
    # upgrade
    for r in $(list | awk -F, 'NR > 1 && $2~/enable/ && $7!~/y/{print $1}'); do _errmsg "upgrade" "$r"; done

    [[ $is_err -eq 0 ]] || exit 1
}

create() {
    SETUP_ROLES_PATH=$(abs_dirname $0)

    if [[ ! -f "$SETUP_ROLES_PATH/_templates/$SETUP_CREATE_TYPE" ]]; then
        log "ERROR" "Error: \"$SETUP_CREATE_TYPE\" is not found under _templates directory"
        exit 1
    fi

    for r in $SETUP_ROLES; do
        if [[ ! -e "$SETUP_ROLES_PATH/$r" ]]; then
            mkdir -p "$SETUP_ROLES_PATH/$r"
            cp "$SETUP_ROLES_PATH/_templates/$SETUP_CREATE_TYPE" "$SETUP_ROLES_PATH/${r}/${SETUP_CREATE_TYPE%.*}"
            log "INFO" "==> Created \"$r\" role"
        else
            log "ERROR" "Error: \"$r\" role is already exists"
        fi
    done
}

edit() {
    SETUP_ROLES_PATH=$(abs_dirname $0)
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

toggle_ed() {
    SETUP_ROLES_PATH=$(abs_dirname $0)

    case $SETUP_FUNC_NAME in
        enable)  local toggle_ed_action="rm -f disable" ;;
        disable) local toggle_ed_action="touch disable" ;;
    esac

    declare -a roles=()
    for SETUP_CURRENT_ROLE_FILE_PATH in $(find "$SETUP_ROLES_PATH"/*/* -type f -name "setup.sh"); do
        SETUP_CURRENT_ROLE_DIR_PATH="${SETUP_CURRENT_ROLE_FILE_PATH%/*}"
        SETUP_CURRENT_ROLE_NAME="${SETUP_CURRENT_ROLE_DIR_PATH##*/}"
        roles+=( $SETUP_CURRENT_ROLE_NAME )
        if in_elements "$SETUP_CURRENT_ROLE_NAME" "$@"; then
            log "INFO" "==> $SETUP_FUNC_NAME $SETUP_CURRENT_ROLE_NAME..."
            (cd $SETUP_CURRENT_ROLE_DIR_PATH && eval "${toggle_ed_action}")
        fi
    done

    # Check role name specified by the parameter
    for t in "$@"; do 
        if ! in_elements "$t" "${roles[@]}"; then
            # Not installed
            log "INFO" "==> $SETUP_FUNC_NAME $t..."
            log "ERROR" "Error: \"$t\" role is not found"
        fi
    done
}

_options() {
    create_options() {
        while getopts ":t:-:" opt; do
            case "$opt" in
                -)  # long option
                    case "${OPTARG}" in
                        type) 
                            shift $((OPTIND -1))
                            SETUP_CREATE_TYPE="setup.sh.$1"
                            shift
                            SETUP_ROLES="$@"
                            ;;
                        *) usage ;;
                    esac
                    ;;
                t)  SETUP_CREATE_TYPE="setup.sh.$OPTARG"
                    shift $((OPTIND -1))
                    SETUP_ROLES="$@"
                    ;;
                *) usage ;;
            esac
        done

        if [[ -z "$SETUP_CREATE_TYPE" ]]; then
            SETUP_CREATE_TYPE="setup.sh.default"
            SETUP_ROLES="$@"
        fi
        [[ -z "$SETUP_ROLES" ]] && usage
    }

    [[ $# -eq 0 ]] && usage
    case "$1" in
        create)     SETUP_FUNC_NAME="create"   ; shift; create_options "$@" ;;
        edit)       SETUP_FUNC_NAME="edit"     ; shift; SETUP_ROLES="$@" ;;
        version)    SETUP_FUNC_NAME="version"  ; shift; SETUP_ROLES="$@" ;;
        list)       SETUP_FUNC_NAME="list"     ; shift; SETUP_ROLES="$@" ;;
        enable)     SETUP_FUNC_NAME="enable"   ; shift; SETUP_ROLES="$@" ;;
        disable)    SETUP_FUNC_NAME="disable"  ; shift; SETUP_ROLES="$@" ;;
        install)    SETUP_FUNC_NAME="install"  ; shift; SETUP_ROLES="$@" ;;
        upgrade)    SETUP_FUNC_NAME="upgrade"  ; shift; SETUP_ROLES="$@" ;;
        config)     SETUP_FUNC_NAME="config"   ; shift; SETUP_ROLES="$@" ;;
        *)          usage ;;
    esac
}

sudov() {
    # See also: https://github.com/caskroom/homebrew-cask/issues/19180
    [[ -z "$SETUP_SUDO_PASSWORD" ]] && sudo -v || sudo -S -v <<< "$SETUP_SUDO_PASSWORD" 2>/dev/null
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
}

main() {
    _options "$@"
    case "$SETUP_FUNC_NAME" in
        create)
            create $SETUP_ROLES ;;
        edit)
            edit $SETUP_ROLES ;;
        version) 
            [[ $# -eq 0 ]] && _check
            version $SETUP_ROLES | column -ts, ;;
        list)
            list | column -ts, ;;
        enable|disable)
            toggle_ed $SETUP_ROLES ;;
        *) # [install|upgrade|config]
            declare -a SETUP_CAVEATS_MSGS=()
            _check
#            sudov
            execute $SETUP_ROLES
            [[ ${#SETUP_CAVEATS_MSGS[@]} -gt 0 ]] && log "WARN" "\nCaveats:"
            for ((i = 0; i < ${#SETUP_CAVEATS_MSGS[@]}; i++)) {
                printf "${SETUP_CAVEATS_MSGS[i]}"
            }
            ;;
    esac
}

main "$@"
