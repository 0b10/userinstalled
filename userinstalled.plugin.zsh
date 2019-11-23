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

function __userinstalled_success () {
    echo `tput setaf 2`success`tput sgr0`": ${1}"
}

function __userinstalled_failed () {
    echo `tput setaf 1`failed`tput sgr0`": ${1}"
}

function __userinstalled_backup () {
    source $__USERINSTALLED_CONFIG_FILE;
    [ -z $USERINSTALLED_FILE ] && echo "you must set USERINSTALLED_FILE in the config file" && return 1;
    
    if [ ! -d `dirname $USERINSTALLED_FILE` ]; then
        mkdir -p `dirname $USERINSTALLED_FILE`;
    fi
    
    # exclude zsh, because it needs to be installed prior to running this script
    local grep_pattern="zsh";
    # add ignored packages to grep pattern
    if [[ ! -z $USERINSTALLED_IGNORED_PACKAGES ]]; then
        echo "excluding packages: "`tput setaf 1`${USERINSTALLED_IGNORED_PACKAGES}`tput sgr0`"..."
        local ignored=`echo $USERINSTALLED_IGNORED_PACKAGES | sed 's/ /|/g'`;
        grep_pattern+="|${ignored}"
    fi
    
    (dnf repoquery --userinstalled --queryformat %{name} | grep -vE "${grep_pattern}" > $USERINSTALLED_FILE) && \
    __userinstalled_success "package names backed up" || \
    __userinstalled_failed "unable to backup package names"
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

function __userinstalled_help() {
    echo -e "Usage: userinstalled [OPTION]";
    
    echo -e "\nOptions:"
    
    echo -e "    help, -h, --help \t\t show this help menu"
    
    echo -e "    backup, -b, --backup \t perform a backup. The same can be achieved
    \t\t\t\t by typing 'userinstalled' without any args"
    
    echo -e "    restore, -r, --restore \t install all packages in the USERINSTALLED_FILE"
    
    echo -e "    edit, -e, --edit \t\t edit the config file"
    
    echo -e "\nExamples:"
    echo -e "    userinstalled"
    echo -e "    userinstalled backup"
    echo -e "    userinstalled edit"
    echo -e "    userinstalled restore"
    echo -e ""
}

function userinstalled () {
    case "$1" in
        "backup"|"-b"|"--backup")
            __userinstalled_backup;
        ;;
        "restore"|"-r"|"--restore")
            __userinstalled_restore;
        ;;
        "edit"|"-e"|"--edit")
            __userinstalled_edit;
        ;;
        "help"|"-h"|"--help")
            __userinstalled_help;
        ;;
        *)
            __userinstalled_backup;
        ;;
    esac
}

userinstalled $@