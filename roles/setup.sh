#!/bin/bash

usage() {
cat << EOS 
Usage: $(basename $0) <command> [option] [<role>...]

Command:
    list     [role...]    List roles (status:[enable|disable], implemented:[y(yes)|n(no)])
    tags     [role...]    List tags and the roles associated with them
    install  [role...]    Install [role...]
    upgrade  [role...]    Upgrade [role...]
    config   [role...]    Configure [role...]
    version  [role...]    Display version of [role...] NOTE: Execute with no [role...] takes time
    disable  [role...]    Disable [role...]
    enable   [role...]    Enable [role...]
    create   <role>...    Create <role>...
    edit     [role]       Edit "setup.sh" of <role> with \$EDITOR (Default: roles/setup.sh)

Option:
    --tags   <tag>...     Only process roles containing "\$SETUP_TAGS_PREFIX<tag>"
                          Multiple tags can be specified by separating them with a comma(,).
    --type   <type>       Only "create" command option
                          "<type>" specifies "setup.sh.<type>" under _templates directory
                          Default: "\$SETUP_TYPE_DEFAULT"

Settings:
    export EDITOR="vim"
    export SETUP_TAGS_PREFIX="tag."
    export SETUP_TYPE_DEFAULT="setup.sh.brew"

Examples:
    $(basename $0) install
    $(basename $0) install brew go direnv
    $(basename $0) create --type brewcask vagrant clipy skitch
    $(basename $0) edit ansible
    $(basename $0) disable --tags GNU_commands,Quicklook
    $(basename $0) tags --tags GNU_commands,Quicklook ag

EOS
exit 1
}

# Settings
SETUP_TAGS_PREFIX="tag."
SETUP_TYPE_DEFAULT="setup.sh.brew"

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
        [[ -e "$SETUP_CURRENT_ROLE_DIR_PATH/disable" ]] && continue
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

version() {
    SETUP_ROLES_PATH=$(abs_dirname $0)

    # Print header
    printf "role,status,version\n"
    declare -a roles=()
    for SETUP_CURRENT_ROLE_FILE_PATH in $(find "$SETUP_ROLES_PATH"/*/* -type f -name "setup.sh"); do
        SETUP_CURRENT_ROLE_DIR_PATH="${SETUP_CURRENT_ROLE_FILE_PATH%/*}"
        SETUP_CURRENT_ROLE_NAME="${SETUP_CURRENT_ROLE_DIR_PATH##*/}"
        roles+=( $SETUP_CURRENT_ROLE_NAME )
        if [[ $# -eq 0 ]] || in_elements "$SETUP_CURRENT_ROLE_NAME" "$@"; then
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

    local role _is_installed _config _version _install _upgrade _status
    for SETUP_CURRENT_ROLE_FILE_PATH in $(find "$SETUP_ROLES_PATH"/*/* -type f -name "setup.sh"); do
        SETUP_CURRENT_ROLE_DIR_PATH="${SETUP_CURRENT_ROLE_FILE_PATH%/*}"
        SETUP_CURRENT_ROLE_NAME="${SETUP_CURRENT_ROLE_DIR_PATH##*/}"

        if [[ $# -gt 0 ]] && ! in_elements "$SETUP_CURRENT_ROLE_NAME" "$@"; then
            continue
        fi

        source "$SETUP_CURRENT_ROLE_FILE_PATH"
        [[ $(type -t is_installed) == "function" ]] && _is_installed="y" || _is_installed="n"
        [[ $(type -t config) == "function" ]] && _config="y" || _config="n"
        [[ $(type -t version) == "function" ]] && _version="y" || _version="n"
        [[ $(type -t install) == "function" ]] && _install="y" || _install="n"
        [[ $(type -t upgrade) == "function" ]] && _upgrade="y" || _upgrade="n"
        _status=$([[ -f "$SETUP_CURRENT_ROLE_DIR_PATH/disable" ]] && echo "disable" || echo "enable")

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
        if [[ $# -eq 0 ]] || in_elements "$SETUP_CURRENT_ROLE_NAME" "$@"; then
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

tags() {
    # Print header
    printf "tag roles\n"
    _tags "$@"
}

_tags() {
    declare -a roles=()
    local tag role
    # find all
    if [[ $# -eq 0 && ${#SETUP_TAGS[@]} -eq 0 ]]; then
        roles=$(find $SETUP_ROLES_PATH/ -type f -name "$SETUP_TAGS_PREFIX*")
    fi
    # find --tags
    for tag in ${SETUP_TAGS[@]}; do
        roles=(${roles[@]} $(find $SETUP_ROLES_PATH/ -type f -iname "$SETUP_TAGS_PREFIX$tag"))
    done
    # find role...
    for role in $@; do
        [[ -d $SETUP_ROLES_PATH/$role ]] || continue
        roles=(${roles[@]} $(find $SETUP_ROLES_PATH/$role/ -type f -iname "$SETUP_TAGS_PREFIX*"))
    done

    declare -a tags_keys=()
    declare -a tags_dict=()
    for role in ${roles[@]}; do
        tag=$(echo ${role##*/} | sed s/$SETUP_TAGS_PREFIX//)
        role=$(basename ${role%/*})
        if ! in_elements "$tag:$role" "${tags_dict[@]}"; then
            tags_dict=("${tags_dict[@]}" "$tag:$role")
        fi
        if ! in_elements "$tag" "${tags_keys[@]}"; then
            tags_keys=(${tags_keys[@]} $tag)
        fi
    done

    local k v _roles
    for tag in ${tags_keys[@]}; do
        for dict in ${tags_dict[@]}; do
            k="${dict%%:*}"
            v="${dict#*:}"
            if [[ "$tag" == "$k" ]]; then
                _roles="$_roles,$v"
            fi
        done
        printf "$tag $(echo $_roles | cut -c 2-)\n"
        unset _roles
    done
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
                    tags)
                        is_parsed=1
                        shift $((OPTIND -1))
                        SETUP_TAGS=($(echo "$1" | tr -s ',', ' '))
                        ;;
                    *) usage ;;
                esac
                ;;
                *) usage ;;
            esac
        done
        [[ "$is_parsed" -eq 0 ]] && SETUP_ROLES="$@" || shift; SETUP_ROLES="$@"
    }

    _parse_create() {
        _parse "$@"
        [[ -z "$SETUP_CREATE_TYPE" ]] && SETUP_CREATE_TYPE="$SETUP_TYPE_DEFAULT"
        [[ -z "$SETUP_ROLES" ]] && usage
    }

    _update_setup_roles() {
        [[ ${#SETUP_TAGS[@]} -eq 0 ]] && return
        local tags_roles="$(_tags | cut -d' ' -f2 | tr ',' '\n')"
        SETUP_ROLES=($(echo $tags_roles ${SETUP_ROLES[@]} | tr ' ' '\n' | sort | uniq))
    }

    [[ $# -eq 0 ]] && usage
    case "$1" in
        create)     SETUP_FUNC_NAME="create"   ; shift; _parse_create "$@";;
        edit)       SETUP_FUNC_NAME="edit"     ; shift; _parse "$@" ;;
        version)    SETUP_FUNC_NAME="version"  ; shift; _parse "$@"; _update_setup_roles ;;
        list)       SETUP_FUNC_NAME="list"     ; shift; _parse "$@"; _update_setup_roles ;;
        tags)       SETUP_FUNC_NAME="tags"     ; shift; _parse "$@" ;;
        enable)     SETUP_FUNC_NAME="enable"   ; shift; _parse "$@"; _update_setup_roles ;;
        disable)    SETUP_FUNC_NAME="disable"  ; shift; _parse "$@"; _update_setup_roles ;;
        install)    SETUP_FUNC_NAME="install"  ; shift; _parse "$@"; _update_setup_roles ;;
        upgrade)    SETUP_FUNC_NAME="upgrade"  ; shift; _parse "$@"; _update_setup_roles ;;
        config)     SETUP_FUNC_NAME="config"   ; shift; _parse "$@"; _update_setup_roles ;;
        *)          usage ;;
    esac
}

sudov() {
    # See also: https://github.com/caskroom/homebrew-cask/issues/19180
    [[ -z "$SETUP_SUDO_PASSWORD" ]] && sudo -v || sudo -S -v <<< "$SETUP_SUDO_PASSWORD" 2>/dev/null
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
}

main() {
    SETUP_ROLES_PATH=$(abs_dirname $0)
    _options "$@"
    case "$SETUP_FUNC_NAME" in
        tags)
            tags ${SETUP_ROLES[@]} | column -t ;;
        create)
            create $SETUP_ROLES ;;
        edit)
            edit $SETUP_ROLES ;;
        version) 
            [[ $# -eq 0 ]] && _check
            version ${SETUP_ROLES[@]} | column -ts, ;;
        list)
            list ${SETUP_ROLES[@]} | column -ts, ;;
        enable|disable)
            toggle_ed ${SETUP_ROLES[@]} ;;
        *) # [install|upgrade|config]
            declare -a SETUP_CAVEATS_MSGS=()
            _check
#            sudov
            execute ${SETUP_ROLES[@]}
            _print_caveats
            ;;
    esac
}

main "$@"
