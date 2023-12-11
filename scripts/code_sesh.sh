#!/bin/bash
# Requirements
#
# THIS SCRIPT ASSUMES YOU STORE ALL YOUR WORK CODE IN ONE DIR
#
# 1. brew install fzf
# 2. alter the dirs variable
dirs=($(find "$HOME/work" -mindepth 1 -maxdepth 1 -type d) "$HOME/learning")

# fuzzy find selected
if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find "${dirs[@]}" -mindepth 1 -maxdepth 1 -type d | fzf)
fi
# if nothing is selected exit
if [[ -z $selected ]]; then
    exit 0
fi
# open with vs-code
code $selected || codium $selected 
