#!/bin/bash

# pretty format zsh per dir history
    # remove unwanted with sed
    # extract the Unix timestamp, convert to local time then print in a specific order with colour
 grep -ri $1 $HOME/.directory_history --color=always \
     | sed 's/.directory_history/ /g; s/::/ /g; s/  */ /g; s/:0;/ /g' \
     | awk '{cmd="date -r " $3 " +\"%Y-%m-%d %H:%M:%S\""; cmd | getline date_str; close(cmd); $3 = date_str; printf "\033[33m%s \033[37m%s", date_str, $1, "\n"; for (i = 4; i <= NF; i++) printf "\033[36m %s", $i; printf "\033[0m\n"}'
