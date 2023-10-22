#!/bin/bash
DOTFILE_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# SCRIPTS --------------------------------------------------------------------
SCRIPTS_DIR="$HOME/.local/bin"
[ -d $SCRIPTS_DIR ] || mkdir $SCRIPTS_DIR
ln -sfn $DOTFILE_DIR/scripts/* $SCRIPTS_DIR

# delete any broken symbolic links
#find -L $HOME/.local/bin -type l -exec rm {}\;

# make new scripts exe
ln -sfn $X/scripts/* $HOME/.local/bin
for file in "$DOTFILE_DIR/scripts/"*; do
    if [ -f "$file" ] && [ -x "$file" ]; then
        filename=$(basename "$file")
        if [ -e "$SCRIPTS_DIR/$filename" ]; then
            echo "chmod +x $SCRIPTS_DIR/$filename"
            chmod +x "$SCRIPTS_DIR/$filename"
        fi
    fi
done

# ZSH ------------------------------------------------------------------------
ln -sfn $DOTFILE_DIR/zsh/zshrc $HOME/.zshrc

# create ZSH_CONFIG_DIR if no dir
ZSH_CONFIG_DIR="$HOME/.config/zsh"
[ -d $ZSH_CONFIG_DIR ] || mkdir $ZSH_CONFIG_DIR

# symbolic link zsh files
for file in "$DOTFILE_DIR/zsh/"*; do
    if [ $file != "$DOTFILE_DIR/zsh/zshrc" ]; then
        if [ -f "$file" ]; then
            ln -sfn $file $ZSH_CONFIG_DIR
        fi
    fi
done

# TMUX -----------------------------------------------------------------------
[ -d "$HOME/.tmux/plugins/tpm" ] || git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
ln -sfn $DOTFILE_DIR/tmux/tmux.conf $HOME/.tmux.conf
tmux source $HOME/.tmux.conf
exec $HOME/.tmux/plugins/tpm/scripts/install_plugins.sh
exec $HOME/.tmux/plugins/tpm/scripts/update_plugins.sh
tmux source $HOME/.tmux.conf
