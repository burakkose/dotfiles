export GITFOLDER=~/git
export DOTFILES=~/dotfiles
export ARCHFLAGS="-arch x86_64"
export ZSH=/usr/share/oh-my-zsh/
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH=$HOME/bin:/usr/local/bin:$PATH

DISABLE_AUTO_UPDATE="true"
HIST_STAMPS="mm/dd/yyyy"

plugins=(git docker jsontools lein mvn sudo web-search )

source $ZSH/oh-my-zsh.sh

# Filesystem
alias .='cd'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cgit='cd $GITFOLDER'
alias dotfiles='cd $DOTFILES'

# Helpers
chpwd() ls
alias c='clear'
alias df='df -h'
alias ping='ping -c 5'
alias lock="sh ~/.bin/lock"
alias zshrc='nano ~/.zshrc'
alias szshrc='source ~/.zshrc'
alias grep='grep --color=auto'
alias reboot='sudo shutdown -r now'
alias shutdown='sudo shutdown -h now'
alias openboxrc='nano ~/.config/openbox/rc.xml'

eval "$(thefuck --alias)"
eval "$(rbenv init -)"

# auto complete for alias
setopt complete_aliases

# zsh-bd
source $HOME/.zsh/plugins/bd/bd.zsh

# git-flow-auto
source $HOME/.zsh/plugins/git-flow-auto/git-flow-completion.zsh

# Theme
ZSH_THEME_GIT_PROMPT_DIRTY='±'

function _git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
  echo "${ref/refs\/heads\// }$(parse_git_dirty)"
}

function _git_info() {
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    local BG_COLOR=green
    if [[ -n $(parse_git_dirty) ]]; then
      BG_COLOR=yellow
      FG_COLOR=black
    fi
    echo "%{%K{$BG_COLOR}%}%{%F{$FG_COLOR}%} $(_git_prompt_info) %{%F{$BG_COLOR}%K{blue}%}"
  else
    echo "%{%K{blue}%}"
  fi
}

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

PROMPT_HOST='%{%b%F{gray}%K{black}%} %(?.%{%F{green}%}✔.%{%F{red}%}✘)%{%F{yellow}%} %n %{%F{black}%}'
PROMPT_DIR='%{%F{white}%} %~%  '
PROMPT_SU='%(!.%{%k%F{blue}%K{black}%}%{%F{yellow}%} ⚡ %{%k%F{black}%}.%{%k%F{blue}%})%{%f%k%b%}'

PROMPT='%{%f%b%k%}$PROMPT_HOST$(_git_info)$PROMPT_DIR$PROMPT_SU
$(virtualenv_info)❯ '
RPROMPT='%{$fg[green]%}[%*]%{$reset_color%}'

USE_STYLE="2"
export INFINALITY_FT_FRINGE_FILTER_STRENGTH="50"
export INFINALITY_FT_USE_VARIOUS_TWEAKS="true"
export INFINALITY_FT_CHROMEOS_STYLE_SHARPENING_STRENGTH="20"
export INFINALITY_FT_GAMMA_CORRECTION="30 80"
export INFINALITY_FT_STEM_ALIGNMENT_STRENGTH="25"
export INFINALITY_FT_STEM_FITTING_STRENGTH="25"
