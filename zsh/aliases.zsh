# neovim
alias vim="nvim"
alias vi="nvim"
alias v="nvim ."
alias n="nvim ."

# start tmux base sessions
alias b="$HOME/.local/bin/tmux_base.sh"
alias base="$HOME/.local/bin/tmux_base.sh"

# util
alias c="clear"
alias h='_h(){$HOME/.local/bin/zsh_history.sh $1}; _h' # history grep
alias prettyPlz='prettier --write .'
alias j="$HOME/.local/bin/sesh.sh"
alias jj="$HOME/.local/bin/code_sesh.sh"
alias s="$HOME/.local/bin/ssh.py"

# misc
alias list="nvim ~/thelist.md"
alias code-ext='code --list-extensions | xargs -L 1 echo code --install-extension'

# conf
alias zshrc='vim ~/.zshrc'
alias vimrc='vim ~/.vimrc'
alias nvimrc='vim ~/.config/nvim'
