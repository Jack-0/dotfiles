#!/bin/bash
# Requirements
#
# THIS SCRIPT ASSUMES YOU STORE ALL YOUR WORK CODE IN ONE DIR
#
# 1. brew install fzf
# 2. change ~/dev to where ever you store your git repos
if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/dev -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

code $selected
