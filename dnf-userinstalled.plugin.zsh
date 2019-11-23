#!/usr/bin/zsh

DNF_USERINSTALLED_TARGET="/tmp/foo/target.txt"

function userinstalled () {
    [[ -z $DNF_USERINSTALLED_TARGET ]] && \
    echo "you must export DNF_USERINSTALLED_TARGET from your zshrc" && return 1;
    
    if [ ! -d `dirname $DNF_USERINSTALLED_TARGET` ]; then
        mkdir -p `dirname $DNF_USERINSTALLED_TARGET`;
    fi
    
    sudo dnf history userinstalled | \
    perl -pe 's/(-[0-9]+[-.:\w]+$)|(Packages installed by user\n)|(^ *$)//gm' > \ # trim version numbers and arch
    $DNF_USERINSTALLED_TARGET && \
    echo "userinstalled: package names backed up";
}
