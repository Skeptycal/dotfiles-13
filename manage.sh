#!/usr/bin/env bash

declare -a oldfiles=()

APPNAME="${0##*/}"
USAGE="$APPNAME <command>

command is one of:
    copy       diff/copy with confirmation
    forcecopy  copy without confirmation
    rmold      remove old files with confirmation"

# diff (current, new) files, asking to copy on difference
function diffcopy(){
    for gitfn in $(cd home/; git ls-tree --name-only -r HEAD .)
    do
        diff "$HOME/$gitfn" home/"$gitfn"
        if [ $? -ne 0 ]
        then
            confirm "copy $gitfn?" && cp home/"$gitfn" "$HOME/$gitfn"
        fi
    done
}

# confirm removal of all $oldfiles
function rmold(){
    for f in $oldfiles;
    do
        rm -i "$f"
    done
}

# copy in current files without diffing/confirming
function forcecopy(){
    pushd home
    find . | cpio -pdv $HOME
    popd
}

# ask a user for confirmation
# return 0 if user types y
# $1: confirmation message
function confirm()
{
    echo -n "$1 (y/n)"
    read -e answer
    if [ "$answer" == 'y' ]
    then
        return 0
    fi

    return 1
}

case "$1" in
    copy)
        diffcopy;;
    forcecopy)
        forcecopy;;
    rmold)
        rmold;;
    *)
        echo "$USAGE";;
esac
