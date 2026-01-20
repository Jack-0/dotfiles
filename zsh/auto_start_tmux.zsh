# automatically start tmux session called base if not in sesh
# Only auto-start tmux if running in Ghostty (appid: com.mitchellh.ghostty)

echo "program $TERM_PROGRAM"

# Get parent process name
PARENT_CMD=$(ps -p $(ps -o ppid= -p $$) -o comm=)

# Debug print
echo "Terminal launched by: $PARENT_CMD"


if [ "$TERM_PROGRAM" = "ghostty" ]; then
    if command -v tmux >/dev/null 2>&1; then
        if [ -z "$TMUX" ]; then
            tmux a -t base || tmux new -s base
        fi
    fi
fi
