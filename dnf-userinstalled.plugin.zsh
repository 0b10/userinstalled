#!/usr/bin/zsh

zmodload zsh/mapfile;

__USERINSTALLED_LOCAL_DIR="$(dirname $0)/";
__USERINSTALLED_CONFIG_TEMPLATE="${__USERINSTALLED_LOCAL_DIR}/userinstalled.config.template";
__USERINSTALLED_CONFIG_FILE="${HOME}/.config/userinstalled-zsh/userinstalled.config.zsh";

if [[ ! -e "$__USERINSTALLED_CONFIG_FILE" ]]; then
    # make a config under .config/userinstalled-zsh
    mkdir -p `dirname ${__USERINSTALLED_CONFIG_FILE}`;
    cp ${__USERINSTALLED_CONFIG_TEMPLATE} ${__USERINSTALLED_CONFIG_FILE};
fi

function __userinstalled_backup () {
    source $__USERINSTALLED_CONFIG_FILE;
    [ -z $USERINSTALLED_FILE ] && echo "you must set USERINSTALLED_FILE in the config file" && return 1;
    
    if [ ! -d `dirname $USERINSTALLED_FILE` ]; then
        mkdir -p `dirname $USERINSTALLED_FILE`;
    fi
    
    # exclude zsh, because it needs to be installed prior to running this script
    # TODO: add ignore packages
    dnf repoquery --userinstalled --queryformat %{name} | grep -v "zsh" > $USERINSTALLED_FILE
    echo "userinstalled: package names backed up";
}

function __userinstalled_restore () {
    source $__USERINSTALLED_CONFIG_FILE;
    [ -z $USERINSTALLED_FILE ] && echo "you must set USERINSTALLED_FILE in the config file" && return 1;
    
    local packages=("${(f@)mapfile[${USERINSTALLED_FILE}]}")
    sudo dnf install ${packages[@]} # don't make string, it causes issues
}

function __userinstalled_edit () {
    if [[ -z $EDITOR ]]; then
        vim $__BB_CONFIG_FILE;
    else
        $EDITOR $__USERINSTALLED_CONFIG_FILE;
    fi
}

function userinstalled () {
    case "$1" in
        "backup"|"-b"|"--backup")
            __userinstalled_backup
        ;;
        "restore"|"-r"|"--restore")
            __userinstalled_restore
        ;;
        "edit"|"-e"|"--edit")
            __userinstalled_edit
        ;;
        *)
            echo "userinstalled: unknown option -- '${1}'"
        ;;
    esac
}

userinstalled $@