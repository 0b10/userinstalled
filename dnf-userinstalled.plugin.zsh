#!/usr/bin/zsh

DNF_USERINSTALLED_TARGET="/tmp/foo/target.txt"

function userinstalled () {
    [[ -z $DNF_USERINSTALLED_TARGET ]] && echo "you must export DNF_USERINSTALLED_TARGET from your zshrc" && return 1;
    
    if [ ! -d `dirname $DNF_USERINSTALLED_TARGET` ]; then
        mkdir -p `dirname $DNF_USERINSTALLED_TARGET`;
    fi
    
}

userinstalled
