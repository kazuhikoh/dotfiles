export LANG=ja_JP.UTF-8

################################# 
# Check OS
################################# 

function get-os-name {
  case $(uname -s) in
    Linux*)  echo 'Linux' ;;
    Darwin*) echo 'MacOS' ;;
    MINGW*)  echo 'Windows' ;;
    *)       echo 'Unknown' ;;
  esac
}
OS_NAME=$(get-os-name)

################################# 
# Key Binding
################################# 

# vim-like style
bindkey -v

# Disable keymaps
bindkey -r '^T' 

# Ctrl-P: EOF (to accept zsh-autosuggestions)
bindkey -M viins '^P' end-of-line

################################# 
# Colors
################################# 

autoload -Uz colors && colors

# Sample
# fg: for c in {000..255}; do echo -n "\e[38;5;${c}m $c" ; [ $(($c%16)) -eq 15  ] && echo;done; echo 
# bg: for c in {000..255}; do echo -n "\e[30;48;5;${c}m $c\e[0m" ; [ $(($c%16)) -eq 15   ] && echo;done; echo

################################# 
# Suggestion
################################# 

# zsh-autosuggestions
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

################################# 
# Completion
################################# 

autoload -Uz compinit

zstyle ':compinstall' filename '~/.zshrc'
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

zstyle ":completion:*:commands" rehash 1

compinit

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Disable zsh builtin commands 
disable r

################################# 
# Prompt
################################# 

# prompt theme
#autoload -Uz promptinit
#promptinit
#prompt adam1

function print-breadcrumb {
  local text=$1
  local fgcolor=$2
  local bgcolor=$3
  local nextcolor="$4"

  local arrow='\ue0b0' # nf-pl-left_hard_divider

  local part_text="%F{$fgcolor}%K{$bgcolor}$text%f%k"
  local part_arrow 
  if [[ $nextcolor == '' ]]; then
    part_arrow="%F{$bgcolor}$arrow%f"
  else
    part_arrow="%F{$bgcolor}%K{$nextcolor}$arrow%f%k"
  fi

  echo "${part_text}${part_arrow}"
}

function print-os-breadcrumb {
  local nextcolor=$1

  local os_icon
  case $OS_NAME in
    Linux) os_icon='\ue712' ;;
    MacOS) os_icon='\ue711' ;;
    Windows) os_icon='\ue70f' ;;
    *) echo "?" ;;
  esac

  local fgcolor=255 # white
  local bgcolor=003 # yellow

  echo "$(print-breadcrumb " $os_icon " $fgcolor $bgcolor $nextcolor)"
}

function print-badge {
  local text="$1"
  local fgcolor=$2
  local bgcolor=$3

  local c_round_l='\ue0b6' # nf-ple-left_half_circle_thick
  local c_round_r='\ue0b4' # nf-ple-right_half_circle_thick

  local t1="%F{$bgcolor}$c_round_l%f"
  local t2="%F{$fgcolor}%K{$bgcolor}$text%f%k"
  local t3="%F{$bgcolor}$c_round_r%f"
  echo "${t1}${t2}${t3}"
}

function get-git-info {
  if [ ! -e ".git" ]; then
    return
  fi

  local branch_name=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
  local branch_status

  local st=$(git status 2> /dev/null)

  if [[ -n $(echo "$st" | grep "^nothing to") ]]; then
    branch_status="clean"
  elif [[ -n $(echo "$st" | grep "^Untracked files") ]]; then
    branch_status="has_untracked"
  elif [[ -n $(echo "$st" | grep "^Changes not staged for commit") ]]; then
    branch_status="has_not_staged"
  elif [[ -n $(echo "$st" | grep "^Changes to be committed") ]]; then
    branch_status="staged"
  elif [[ -n $(echo "$st" | grep "^rebase in progress") ]]; then
    branch_status="rebase"
  else
    branch_status=""
  fi

  echo -n "$branch_name $branch_status"
}

function print-git-badge {
  local arr=( $(get-git-info) )
  local git_branch=${arr[1]}
  local git_status=${arr[2]}

  if [[ "$git_branch" == '' ]]; then
    return
  fi

  local t_icon='\ue725'    # nf-dev-git_branch
  local t_branch="$git_branch"
  local t_status=$(
    case "$git_status" in
      clean)          echo "" ;;
      has_untracked)  echo "|?" ;;
      has_not_staged) echo "|+" ;;
      has_staged)     echo "|!" ;;
      *) echo "" ;
    esac
  )

  local fgcolor=255 # white
  local bgcolor=003 # yellow

  echo "$(print-badge "${t_icon} ${t_branch}${t_status}" $fgcolor $bgcolor)"
}

function print-prompt {
  local exitcode=$?
  
  # [os-icon > directory > 
  
  local t_os="$(print-os-breadcrumb)"

  local t_face
  if [[ $exitcode == 0 ]]; then
    t_face="${fg[yellow]}(⊃＾ω＾)⊃${reset_color} "
  else
    t_face="${fg[red]}(⊃＾ω＾)⊃${reset_color} "
  fi

  echo "${t_os}${t_face}" 
}

function print-rprompt {
  local exitcode=$?
  local exitcode_icon='\uf06a' # nf-fa-exclamation_circle
  local exitcode_badge=$(
    if [[ $exitcode != 0 ]]; then
      print-badge "$exitcode_icon $exitcode" 255 009
    fi 
  )

  echo "${exitcode_badge}$(print-git-badge)"
}

setopt prompt_subst
PROMPT='$(print-prompt)'
RPROMPT='$(print-rprompt)'
#PROMPT2=
#SPROMPT=

# #############################
# Hook functions
# #############################

chpwd() {
  # iTerm2 tab name
  echo -ne "\033]0;$(pwd | rev | awk -F \/ '{print "/"$1"/"$2}'| rev)\007"
}

################################
# User Command
################################# 

export PATH=$PATH:~/bin

export PAGER=less
export LESS='-iNMRj.5'

export EDITOR=vim
export GIT_EDITOR=vim

################################# 
# Alias
################################# 

alias l='ls --color=auto'
alias ll='ls -alF --color=auto'
alias l1='ls -a1 --color=auto'

alias d='cd "./$(ls -d1 */ | fzf)"'

alias h='history'

alias grep="grep --color=auto"

alias v='vim'



# For Mac
{
  # GNU tools
  if [[ -e "/usr/local/opt/coreutils/libexec/gnubin"  ]]; then
    PATH="/usr/local/opt/coreutils/libexec/gnubin:${PATH}"
    MANPATH="/usr/local/opt/coreutils/libexec/gnuman:${MANPATH}"
  fi
  if [[ -e "/usr/local/opt/grep/libexec/gnubin"  ]]; then
    PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
    MANPATH="/usr/local/opt/grep/libexec/gnuman:$MANPATH"
  fi
}

# For Cygwin
if [[ "$(uname -o)" == Cygwin ]] ; then

  alias m="mintty.exe --daemon"
  alias s=cygstart

  alias desktop="cd $(cygpath --desktop); pwd"
  alias home="cd $(cygpath --home)/$USER; pwd"
  
  # kill windows process
  # ("ps -W" lists windows processes.)
  alias wkill='taskkill /F /pid $@'
  
  # sudo
  if [[ -n "$PS1" ]]; then
      cygsudo() {
          local executable=$(which "${1:-cmd}")
          shift
          /usr/bin/cygstart --action=runas "$executable" "$@"
      }
  
      if [[ -x "/usr/bin/cygstart" ]]; then
          alias sudo=cygsudo
      fi
  fi

fi  

# function ###############################

# fenc <from> <to> <filepath>
fenc() {
  if ! type vim > /dev/null; then
    echo "Vim is our help and shield."
    exit 1;
  fi

  local from="$1"
  local to="$2"
  local filepath="$3"
  : ${from:?} ${to:?} ${filepath:?}

  vim -c ":e ++enc=${from}" -c "set fenc=${to}" -c ":wq" "$filepath"
}

# ff <file-format>
ff() {
  if ! type vim > /dev/null; then
    echo "Vim is our help and shield."
    exit 1;
  fi

  local format="$1"
  local filepath="$2"
  : ${format:?} ${filepath:?}

  vim -c ":set ff=${format}" -c ":wq" "$filepath"
}

# style ###############################

# dir_colors
if type -p dircolors >/dev/null ; then
    eval $(dircolors ~/.dir_colors)
fi

# theme (Cygwin)

if [[ $OS_NAME == Windows ]] ; then
  # Solarized
  source "$GOPATH/src/github.com/mavnn/mintty-colors-solarized/sol.light"
fi

# Plugin Manager #############################

# zplug [https://github.com/zplug/zplug]
# - Zsh Plugin Manager
export ZPLUG_HOME=~/.zplug
if [[ ! -f ${ZPLUG_HOME}/init.zsh ]]; then
  echo "NOT INSTALLED: zplug/zplug (https://github.com/zplug/zplug)"
else
	source ~/.zplug/init.zsh

	zplug "b4b4r07/enhancd", use:init.sh
	zplug "zdharma/fast-syntax-highlighting"

	# zplug check returns true if all packages are installed
	# Therefore, when it returns false, run zplug install
	if ! zplug check --verbose; then
		printf 'Install? [y/N]: '
		if read -q; then
			echo; zplug install
		fi
	fi
	
	# source plugins and add commands to the PATH
	zplug load

	# zplug check returns true if the given repository exists
	if zplug check 'b4b4r07/enhancd'; then
		# setting if enhancd is available
		export ENHANCD_FILTER=fzf
	fi
fi

# Zsh Widgets ###############################

function ghqlist () {
	local selected_dir=$(ghq list -p | fzf --query "$LBUFFER")
	if [ -n "$selected_dir" ]; then
		BUFFER="cd ${selected_dir}"
		zle accept-line
	fi
}
zle -N ghqlist
bindkey '^]' ghqlist

# dev ###############################

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# golang

export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:$GOPATH/bin

## syndbg/goenv
export GOENV_ROOT="$HOME/go/src/github.com/syndbg/goenv"
export PATH="$GOENV_ROOT/bin:$PATH"

if [ -d "$GOENV_ROOT" ]; then
  eval "$(goenv init -)"
else
  echo "Please clone syndbg/goenv to $GOENV_ROOT" >&2
fi

# Python

# pyenv/pyenv
export PYENV_ROOT="$HOME/go/github.com/pyenv/pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if [ -d "$PYENV_ROOT" ]; then
  eval "$(pyenv init -)"
else
  echo "Please clone pyenv/pyenv to $PYENV_ROOT"
fi

# Java

# jenv (http://www.jenv.be/)
# Java environment manager
if [[ -d $HOME/.jenv/bin ]]; then
  export PATH="$HOME/.jenv/bin:$PATH"
  eval "$(jenv init -)"
else
  echo "Please clone gcuisinier/jenv to ~/.jenv" >&2
fi

# sdkman (sdkman.io)

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="${HOME}/.sdkman"
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"

# Node.js

# nodebrew (https://github.com/hokaccha/nodebrew)
# Node.js version manager
export PATH=$HOME/.nodebrew/current/bin:$PATH

# Android

if [[ "$(uname)" == 'Darwin' ]]; then
  export PATH="$HOME/Library/Android/sdk/platform-tools":$PATH
fi

