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

################################

# prompt
PROMPT='%(?.%F{yellow}(⊃＾ω＾)⊃%f.%F{red}(⊃＾ω＾%)⊃%f) '
#PROMPT2=
#SPROMPT=
#RPROMPT=

# aliases
alias ls='ls --color=auto'
alias ll='ls -alF --color=auto'
alias grep='grep --color=auto'

alias findf='function(){ find . -type f -name $1 }'
alias findd='function(){ find . -type d -name $1 }'

alias gbuild='function(){ for dir in $@; do echoGreen "======== $dir ========"; ( cd $dir && gradle clean build -x test -x check ); done }'
alias gclean='function(){ for dir in $@; do echoGreen "======== $dir ========"; ( cd $dir && gradle clean ); done }'

# echo with ANSI Colors
echoRed() { echo $'\e[0;31m'"$1"$'\e[0m'; }
echoGreen() { echo $'\e[0;32m'"$1"$'\e[0m'; }
echoYellow() { echo $'\e[0;33m'"$1"$'\e[0m'; }

# cygwin
if [ -f "${HOME}/.sh_cygwin" ]; then
  source "${HOME}/.sh_cygwin"
fi

# extra
if [ -f "${HOME}/.sh_extra" ]; then
  source "${HOME}/.sh_extra"
fi

################################

# User Command
export PATH=$PATH:~/bin

export PAGER=less
export LESS='-iNMRj.5'

export EDITOR=vim
export GIT_EDITOR=vim

# golang
# https://golang.org
export GOROOT=/usr/local/go
export GOPATH=$HOME/.go
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:$GOPATH/bin

# jenv [http://www.jenv.be/]
# - Java environment manager
if [[ -d $HOME/.jenv/bin ]]; then
  export PATH="$HOME/.jenv/bin:$PATH"
  eval "$(jenv init -)"
fi

# nodebrew [https://github.com/hokaccha/nodebrew]
# - Node.js version manager
export PATH=$HOME/.nodebrew/current/bin:$PATH

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/kazuhiko/.sdkman"
[[ -s "/home/kazuhiko/.sdkman/bin/sdkman-init.sh" ]] && source "/home/kazuhiko/.sdkman/bin/sdkman-init.sh"

# fzf (https://github.com/junegunn/fzf)
# Installation using ghq
# % ghq get https://github.com/junegunn/fzf.git
# % ln -s $(ghq list --full-path | grep junegunn/fzf) ~/.fzf
# % ~/.fzf/install
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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

