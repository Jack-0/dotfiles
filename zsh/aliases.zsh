# neovim
alias vim="nvim"
alias v="nvim"
alias vi="nvim"
alias n="nvim"

# start tmux base sessions
alias b="tmux attach -t base || tmux new -s base"

# util
alias c="clear"
alias h='_h(){$HOME/.local/bin/zsh_history.sh $1}; _h' # history grep
alias prettyPlz='prettier --write .'
alias j="~/sesh.sh"
alias jj="~/.code_sesh.sh"

# misc
alias list="nvim ~/thelist.md"
alias code-ext='code --list-extensions | xargs -L 1 echo code --install-extension'

# conf
alias zshrc='vim ~/.zshrc'
alias vimrc='vim ~/.vimrc'
alias nvimrc='vim ~/.config/nvim'
