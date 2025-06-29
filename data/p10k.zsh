# 1. Prompt Segments: Layout
# --------------------------
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  context            # user@host
  dir                # current directory
  vcs                # git status
  git_commit_age     # custom segment: time since last commit
  newline            # line break
  virtualenv         # python venv
  prompt_char        # λ or error symbol
)

typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  status                 # non-zero exit codes
  command_execution_time # command duration (≥ threshold)
  time                   # current time
)

# 2. Global Style
# ---------------
typeset -g POWERLEVEL9K_BACKGROUND=
typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=
typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '
typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=
typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

# 3. Colors and Icons
# -------------------
local grey=252 red=196 yellow=226 blue=33 magenta=201 cyan=51 white=15

typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE="%F{${yellow}}%n%f%F{${grey}}@%m%f"
typeset -g POWERLEVEL9K_DIR_FOREGROUND=4

typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=${blue}
typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
typeset -g POWERLEVEL9K_VIRTUALENV_LEFT_DELIMITER=''
typeset -g POWERLEVEL9K_VIRTUALENV_RIGHT_DELIMITER=''

typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS}_FOREGROUND=${yellow}
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS}_FOREGROUND=${red}
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_{VIINS,VICMD,VIVIS}_CONTENT_EXPANSION='λ'
typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=false

typeset -g POWERLEVEL9K_VCS_FOREGROUND=${white}
typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=''
typeset -g POWERLEVEL9K_VCS_STAGED_ICON='✓'
typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON='△'
typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='◒'
typeset -g POWERLEVEL9K_VCS_DIRTY_ICON='✗'
typeset -g POWERLEVEL9K_VCS_DELETED_ICON='✖'
typeset -g POWERLEVEL9K_VCS_RENAMED_ICON='➜'
typeset -g POWERLEVEL9K_VCS_UNMERGED_ICON='§'
typeset -g POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON='⇣'
typeset -g POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON='⇡'
typeset -g POWERLEVEL9K_VCS_{INCOMING,OUTGOING}_CHANGESFORMAT_FOREGROUND=${cyan}
typeset -g POWERLEVEL9K_VCS_{COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=1

typeset -g POWERLEVEL9K_STATUS_OK=false
typeset -g POWERLEVEL9K_STATUS_ERROR=true
typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=${red}

typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='h:m:s'
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=${yellow}

typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
typeset -g POWERLEVEL9K_TIME_FOREGROUND=2
typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=true

# 4. Custom Segment: git_commit_age
# ----------------------------------
function prompt_git_commit_age() {
  emulate -L zsh
  local last now diff minutes hours days age color
  git rev-parse --git-dir &>/dev/null || return
  last=$(git log -1 --pretty='%at' 2>/dev/null) || return
  now=$EPOCHSECONDS
  diff=$(( now - last ))
  minutes=$(( diff / 60 ))
  hours=$(( diff / 3600 ))
  days=$(( diff / 86400 ))

  if   (( hours >= 24 )); then age="${days}d"
  elif (( minutes >= 60 )); then age="$(( hours % 24 ))h$(( minutes % 60 ))m"
  else                           age="${minutes}m"
  fi

  if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
    if   (( hours > 4 ));    then color=${red}
    elif (( minutes > 30 )); then color=${yellow}
    else                          color=${white}
    fi
  else
    color=${white}
  fi

  p10k segment -f $color -t "$age"
}

# 5. Instant Prompt & Misc
# ------------------------
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true
typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}

# Reload p10k if already active
(( ! $+functions[p10k] )) || p10k reload
