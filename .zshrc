# ~/.oh-my-zsh

# Path to your oh-my-zsh installation.
export ZSH="~/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(git)

# Source
source $ZSH/oh-my-zsh.sh

# User configuration

# Aliases
alias vimrc='vim ~/.vimrc'  	# edit vimrc
alias zshrc='vim ~/.zshrc'  	# edit zshrc
alias p='sudo pacman -S'    	# pacman install
alias update='sudo pacman -Syu' # update system
#git
alias gl='git log --oneline'	# compact git log
