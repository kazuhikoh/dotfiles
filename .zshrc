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
PROMPT='%(?.%F{yellow}(⊃＾ω＾)⊃%f.%F{red}(⊃＾ω＾%)⊃%f) '
#PROMPT2=
#SPROMPT=
#RPROMPT=

################################

# env
if [ -f "${HOME}/etc/.envrc" ]; then
  source "${HOME}/etc/.envrc"
fi

# alias
if [ -f "${HOME}/etc/.aliasrc" ]; then
  source "${HOME}/etc/.aliasrc"
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
if [[ -f ~/${ZPLUG_HOME}/init.zsh ]]; then
	source ~/.zplug/init.zsh

	# zplug check returns true if all packages are installed
	# Therefore, when it returns false, run zplug install
	if ! zplug check --verbose; then
		printf 'Install? [y/N]: '
		if read -q; then
			echo; zplug install
		fi
	fi

	zplug "b4b4r07/enhancd", use:init.sh
	
	# source plugins and add commands to the PATH
	zplug load

	# zplug check returns true if the given repository exists
	if zplug check 'b4b4r07/enhancd'; then
		# setting if enhancd is available
		export ENHANCD_FILTER=fzf
	fi
fi

