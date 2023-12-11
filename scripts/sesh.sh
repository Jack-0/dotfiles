#!/bin/bash
# sesh.sh
# Create a tmux session for a directory. Looks for sub-dirs from the parent directory
#
# Requirements
#
# THIS SCRIPT ASSUMES YOU STORE ALL YOUR WORK CODE IN ONE DIR
# IT ALSO ASSUMES YOU ARE RUNNING TMUX
#
# 1. brew install fzf
# 2. change 'dirs' to directories you would like to fuzzy filter
dirs=("$HOME/pdev" "$HOME/learning" $(find "$HOME/work" -mindepth 1 -maxdepth 1 -type d))

# fuzzy select session
if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find "${dirs[@]}" -mindepth 1 -maxdepth 1 -type d | fzf)
fi
selected_name=$(basename "$selected" | tr . _)
# fail if no selection
if [[ -z $selected ]]; then
    exit 0
fi
# handle the edge case that we are not currently in tmux
tmux_running=$(pgrep tmux)
if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected
    exit 0
fi
# create session if it doesn't exist and in tmux
if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected
fi
# attach to session
tmux switch-client -t $selected_name
