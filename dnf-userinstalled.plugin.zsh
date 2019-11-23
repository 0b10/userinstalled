#!/usr/bin/zsh

DNF_USERINSTALLED_TARGET="/tmp/foo/target.txt"

function _userinstalled_backup () {
    if [ ! -d `dirname $DNF_USERINSTALLED_TARGET` ]; then
        mkdir -p `dirname $DNF_USERINSTALLED_TARGET`;
    fi
    
    sudo dnf history userinstalled | \
    perl -pe 's/(-[0-9]+[-.:\w]+$)|(Packages installed by user\n)|(^ *$)//gm' > \
    $DNF_USERINSTALLED_TARGET && \
    echo "userinstalled: package names backed up";
}

function _userinstalled_restore () {
    echo restoring
}

function userinstalled () {
    [[ -z $DNF_USERINSTALLED_TARGET ]] && \
    echo "you must export DNF_USERINSTALLED_TARGET from your zshrc" && return 1;
    
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
