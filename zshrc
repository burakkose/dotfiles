export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH=/home/burakkose/.oh-my-zsh

ZSH_THEME="agnoster"

DISABLE_AUTO_UPDATE="true"

HIST_STAMPS="mm/dd/yyyy"

plugins=(git command-not-found docker jsontools lein mvn sudo web-search )

source $ZSH/oh-my-zsh.sh

export ARCHFLAGS="-arch x86_64"

eval "$(thefuck --alias)"
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
alias lock="sh ~/.bin/lock"
