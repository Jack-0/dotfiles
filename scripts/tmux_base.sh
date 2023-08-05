#!/bin/bash
if [ "$TERM_PROGRAM" = tmux ]; then
    # create base session
    if ! tmux has-session -t=base 2> /dev/null; then
        tmux new-session -ds base -c $HOME
    fi
    # attach to base session
    tmux switch-client -t base
else
    # no tmux session attach or create and attach
    tmux attach -t base || tmux new -s base -c $HOME
fi
