#!/bin/bash
# Requirements
#
# THIS SCRIPT ASSUMES YOU STORE ALL YOUR WORK CODE IN ONE DIR
# IT ALSO ASSUMES YOU ARE RUNNING TMUX
#
# 1. brew install fzf
# 2. change ~/dev to where ever you store your git repos
if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/pdev ~/dev ~/learning -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    echo "new session"
    tmux new-session -s $selected_name -c $selected
    exit 0
fi

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    echo "new session -ds"
    tmux new-session -ds $selected_name -c $selected
fi

echo "session switch"
echo $selected_name
tmux switch-client -t $selected_name
