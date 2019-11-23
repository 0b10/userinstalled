#!/usr/bin/zsh

zmodload zsh/mapfile;

DNF_USERINSTALLED_FILE="/tmp/foo/target.txt"

function _userinstalled_backup () {
    if [ ! -d `dirname $DNF_USERINSTALLED_FILE` ]; then
        mkdir -p `dirname $DNF_USERINSTALLED_FILE`;
    fi
    
    # exclude zsh, because it needs to be installed prior to running this script
    # TODO: add ignore packages
    dnf repoquery --userinstalled --queryformat %{name} | grep -v "zsh" > $DNF_USERINSTALLED_FILE
    echo "userinstalled: package names backed up";
}

function _userinstalled_restore () {
    local packages=("${(f@)mapfile[${DNF_USERINSTALLED_FILE}]}")
    sudo dnf install ${packages[@]} # don't make string, causes issues
}

function userinstalled () {
    [[ -z $DNF_USERINSTALLED_FILE ]] && \
    echo "you must export DNF_USERINSTALLED_FILE from your zshrc" && return 1;
    
    case "$1" in
        "backup"|"-b"|"--backup")
            _userinstalled_backup
        ;;
        "restore"|"-r"|"--restore")
            _userinstalled_restore
        ;;
        *)
            echo "userinstalled: unknown option -- '${1}'"
        ;;
    esac
}

userinstalled $@