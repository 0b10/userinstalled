#!/usr/bin/zsh

function userinstalled () {
    [[ -z $DNF_USERINSTALLED_TARGET ]] && echo "you must export DNF_USERINSTALLED_TARGET";
}

userinstalled
