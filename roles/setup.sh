#!/bin/bash

usage() {
cat << EOS 
Usage: $(basename $0) <command> [option] [<roles...>]

Command:
    install  [roles...]   Install roles
    upgrade  [roles...]   Upgrade roles
    config   [roles...]   Configure roles
    version  [roles...]   Display version of roles
    list     [roles...]   List roles (status: enable, disable, None=not installed, Error=not implemented or role not found)
    disable  [roles...]   Disable roles
    enable   [roles...]   Enable roles
#    dotfiles [roles...]   Output dofiles to the dotfiles directory (need to implement the "dotfiles" function)
    create   <roles...>   Create the specified role
    edit     <roles...>   Edit the specified role setup.sh (Open \$EDITOR: default vim)
    check                 Check whether setup.sh for each role implements the required function (ok=implemented, -=not implemented)

Option:
    --clear               Clear "setup.versions" file and reacquire the list (only "list" command)
    --type, -t <type>     "<type>" specifies "setup.sh.<type>" under _templates directory (only "create" command)
                          not specify an option, "setup.sh.default" is selected

Examples:
    $(basename $0) install
    $(basename $0) install brew go direnv
    $(basename $0) create --type brew direnv
    $(basename $0) check

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
        ERROR)  printf "\e[32m$msg\e[m\n" ;;
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
        INFO)   caveats="\e[7;34m$msg\e[m\n" ;;
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
            [[ $is_depend -eq 1 ]] && log "INFO" "====> Install dependency: \"$SETUP_CURRENT_ROLE_NAME\"..."
            install
            [[ $? -ne 0 ]] && log "ERROR" "Error: occurred during \"$SETUP_CURRENT_ROLE_NAME\" \"install\"" && exit 1
        fi

        case "$func" in
            install) # do nothing
                ;;
            *)  # [upgrade|config|version]
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

    # [install|upgrade|config|version]
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

list() {
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

check() {
    SETUP_ROLES_PATH=$(abs_dirname $0)

    # Print header
    # printf "role,status,is_installed,config,version,install,upgrade,dotfile\n"
    printf "role,status,is_installed,config,version,install,upgrade\n"
    for SETUP_CURRENT_ROLE_FILE_PATH in $(find "$SETUP_ROLES_PATH"/*/* -type f -name "setup.sh"); do
        SETUP_CURRENT_ROLE_DIR_PATH="${SETUP_CURRENT_ROLE_FILE_PATH%/*}"
        SETUP_CURRENT_ROLE_NAME="${SETUP_CURRENT_ROLE_DIR_PATH##*/}"

        source "$SETUP_CURRENT_ROLE_FILE_PATH"
        [[ $(type -t is_installed) == "function" ]] && _is_installed="ok" || _is_installed="-"
        [[ $(type -t config) == "function" ]] && _config="ok" || _config="-"
        [[ $(type -t version) == "function" ]] && _version="ok" || _version="-"
        [[ $(type -t install) == "function" ]] && _install="ok" || _install="-"
        [[ $(type -t upgrade) == "function" ]] && _upgrade="ok" || _upgrade="-"
       # [[ $(type -t dotfile) == "function" ]] && _dotfile="ok" || _dotfile="-"
        local _status=$([[ -f "$SETUP_CURRENT_ROLE_DIR_PATH/disable" ]] && echo "disable" || echo "enable")

        # printf "$SETUP_CURRENT_ROLE_NAME,$_status,$_is_installed,$_config,$_version,$_install,$_upgrade,$_dotfile\n"
        printf "$SETUP_CURRENT_ROLE_NAME,$_status,$_is_installed,$_config,$_version,$_install,$_upgrade\n"

        unset -f is_installed
        unset -f config
        unset -f version
        unset -f install
        unset -f upgrade
        # unset -f dotfile
    done
}

_check() {
    # It checks the implementation status of functions of each role, and terminates processing if not implemented.
    local is_err=0

    _errmsg() {
        log "ERROR" "Error: \"$1\" function is not implemented in \"$2\" role"
        is_err=1
    }

    # TODO: 遅いので方式変更する 
    # is_installed
    for r in $(check | awk -F, 'NR > 1 && $2~/enable/ && $3!~/ok/{print $1}'); do _errmsg "is_installed" "$r"; done
    # config
    for r in $(check | awk -F, 'NR > 1 && $2~/enable/ && $4!~/ok/{print $1}'); do _errmsg "config" "$r"; done
    # version
    for r in $(check | awk -F, 'NR > 1 && $2~/enable/ && $5!~/ok/{print $1}'); do _errmsg "version" "$r"; done
    # install
    for r in $(check | awk -F, 'NR > 1 && $2~/enable/ && $6!~/ok/{print $1}'); do _errmsg "install" "$r"; done
    # upgrade
    for r in $(check | awk -F, 'NR > 1 && $2~/enable/ && $7!~/ok/{print $1}'); do _errmsg "upgrade" "$r"; done
    # dotfile
    # for r in $(check | awk -F, 'NR > 1 && $2~/enable/ && $8!~/ok/{print $1}'); do _errmsg "dotfile" "$r"; done

    # [[ $(check | awk -F, 'NR > 1 && $2~/enable/{print $0}' | grep '-' | wc -l) -gt 0 ]] && exit 1
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

options() {
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

    list_options() {
        while getopts ":-:" opt; do
            case "$opt" in
                -)  # long option
                    case "${OPTARG}" in
                        clear) SETUP_CLEAR_OPTIONS=1 ;;
                        *) usage ;;
                    esac
                    ;;
                *) usage ;;
            esac
        done
    }

    [[ $# -eq 0 ]] && usage
    case "$1" in
        install)    SETUP_FUNC_NAME="install"  ;;
        config)     SETUP_FUNC_NAME="config"   ;;
        version)    SETUP_FUNC_NAME="version"  ;;
        upgrade)    SETUP_FUNC_NAME="upgrade"  ;;
        check)      SETUP_FUNC_NAME="check"    ;;
        enable)     SETUP_FUNC_NAME="enable"   ;;
        disable)    SETUP_FUNC_NAME="disable"  ;;
        dotfiles)   SETUP_FUNC_NAME="dotfile"  ;;
        list)       SETUP_FUNC_NAME="list"     ; shift; list_options "$@" ;;
        create)     SETUP_FUNC_NAME="create"   ; shift; create_options "$@" ;;
        edit)       SETUP_FUNC_NAME="edit"     ; shift; SETUP_ROLES="$@" ;;
        *)          usage ;;
    esac
}

sudov() {
    # See also: https://github.com/caskroom/homebrew-cask/issues/19180
    [[ -z "$SETUP_SUDO_PASSWORD" ]] && sudo -v || sudo -S -v <<< "$SETUP_SUDO_PASSWORD" 2>/dev/null
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
}

main() {
    options "$@"
    case "$SETUP_FUNC_NAME" in
        create)
            create "$SETUP_ROLES" ;;
        edit)
            edit "$SETUP_ROLES" ;;
        list) 
            SETUP_ROLES_PATH=$(abs_dirname $0)
            local versionfile="$SETUP_ROLES_PATH/.setup-versions"
            shift 
            [[ "$SETUP_CLEAR_OPTIONS" -eq 1 ]] && shift && rm -f "$versionfile"
            if [[ $# -eq 0 ]]; then
                if [[ -s "$versionfile" ]]; then
                    cat "$versionfile" 
                else
                    _check
                    { list "$@" | column -ts, > "$versionfile"; } && cat "$versionfile"
                fi
            else
                list "$@" | column -ts,
            fi
            ;;
        check)
            shift; check | column -ts, ;;
        enable|disable)
            shift; toggle_ed "$@" ;;
        dotfile)
            _check
            setup_roles_path=$(abs_dirname $0)
            setup_dotfiles_path="${setup_roles_path%/*}/dotfiles"
            mkdir -p "$SETUP_DOTFILES_PATH"
            shift; execute "$@" ;;
        *) # [install|upgrade|config|version]
            declare -a SETUP_CAVEATS_MSGS=()
            _check
#            sudov
            shift; execute "$@"
            [[ ${#SETUP_CAVEATS_MSGS[@]} -ge 0 ]] && log "WARN" "Caveats:"
            for ((i = 0; i < ${#SETUP_CAVEATS_MSGS[@]}; i++)) {
                printf "${SETUP_CAVEATS_MSGS[i]}"
            }
            ;;
    esac
}

main "$@"
