bindkey -v

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

compinit

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history


# prompt theme
#autoload -Uz promptinit
#promptinit
#prompt adam1

# prompt

function rprompt-git-current-branch {
  local branch_name st branch_status

  if [ ! -e ".git" ]; then
    return
  fi

  branch_name=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
  st=$(git status 2> /dev/null)

  if [[ -n $(echo "$st" | grep "^nothing to") ]]; then
    branch_status="%F{green}"
  elif [[ -n $(echo "$st" | grep "^Untracked files") ]]; then
    branch_status="%F{red}?"
  elif [[ -n $(echo "$st" | grep "^Changes not staged for commit") ]]; then
    branch_status="%F{red}+"
  elif [[ -n $(echo "$st" | grep "^Changes to be committed") ]]; then
    branch_status="%F{yellow}!"
  elif [[ -n $(echo "$st" | grep "^rebase in progress") ]]; then
    echo "%F{red}!(no branch)"
    return
  else
    branch_status="%F{blue}"
  fi

  echo "${branch_status}[$branch_name]"
}

setopt prompt_subst

PROMPT='%(?.%F{yellow}(⊃＾ω＾)⊃%f.%F{red}(⊃＾ω＾%)⊃%f) '
RPROMPT='$(rprompt-git-current-branch)'

#PROMPT2=
#SPROMPT=

################################

# User Command
export PATH=$PATH:~/bin

################################

export LANG=ja_JP.UTF-8

export PAGER=less
export LESS='-iNMRj.5'

export EDITOR=vim
export GIT_EDITOR=vim

# alias ###############################

alias ls='ls --color=auto'
alias ll='ls -alF --color=auto'
alias l='ls -a1 --color=auto'

alias h='history'

alias grep="grep --color=auto"

alias v='vim'

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

if [[ "$(uname -o)" == Cygwin ]] ; then
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

