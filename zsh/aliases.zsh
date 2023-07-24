# neovim
alias vim="nvim"
alias v="nvim"
alias vi="nvim"
alias n="nvim"

# util
#alias h='_h(){ grep "$1" ~/.zsh_history ;}; _h'
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

alias h='_h(){$HOME/.local/bin/zsh_history.sh $1}; _h'
