# automatically start tmux session called base if not in sesh
if command -v tmux >/dev/null 2>&1; then
    if [ -z "$TMUX" ]; then
        tmux a -t base || tmux new -s base
    fi
fi

