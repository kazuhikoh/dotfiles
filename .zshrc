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

export LANG=ja_JP.UTF-8

# env
if [ -f "${HOME}/etc/.envrc" ]; then
  source "${HOME}/etc/.envrc"
fi

# alias
if [ -f "${HOME}/etc/.aliasrc" ]; then
  source "${HOME}/etc/.aliasrc"
fi

# function
if [ -f "${HOME}/etc/.funcrc.zsh" ]; then
  source "${HOME}/etc/.funcrc.zsh"
fi

# colors
if [ -f "${HOME}/etc/.colorrc" ]; then
  source "${HOME}/etc/.colorrc"
fi

# cygwin
if [ -f "${HOME}/etc/.aliasrc.cygwin" ]; then
  source "${HOME}/etc/.aliasrc.cygwin"
fi

if [ -f "${HOME}/etc/.cygwinrc" ]; then
  source "${HOME}/etc/.cygwinrc"
fi

# extra
if [ -f "${HOME}/etc/.extrarc" ]; then
  source "${HOME}/etc/.extrarc"
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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
