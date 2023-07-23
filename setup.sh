#!/bin/bash
DOTFILE_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# add scripts to users account
ln -s $DOTFILE_DIR/scripts/* $HOME/.local/bin

# delete any broken symbolic links
#find -L $HOME/.local/bin -type l -exec rm {}\;

# make new scripts exe
ln -s $X/scripts/* $HOME/.local/bin
for file in "$DOTFILE_DIR/scripts/"*; do
    if [ -f "$file" ] && [ -x "$file" ]; then
        filename=$(basename "$file")
        if [ -e "$HOME/.local/bin/$filename" ]; then
            echo "chmod +x $HOME/.local/bin/$filename"
            chmod +x "$HOME/.local/bin/$filename"
        fi
    fi
done

