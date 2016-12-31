zstyle :compinstall filename '~/.zshrc'

# Use modern completion system
autoload -Uz compinit
compinit

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
PROMPT='%F{yellow}%n@%m%# %f'
#PROMPT2=
#SPROMPT=
#RPROMPT=

# aliases
alias ls='ls --color=auto'
alias ll='ls -alF --color=auto'
alias grep='grep --color=auto'

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

export EDITOR=vim
export GIT_EDITOR=vim

# jenv [http://www.jenv.be/]
# - Java environment manager
if [[ -d $HOME/.jenv/bin ]]; then
  export PATH="$HOME/.jenv/bin:$PATH"
  eval "$(jenv init -)"
fi

# nodebrew [https://github.com/hokaccha/nodebrew]
# - Node.js version manager
if type nodebrew >/dev/null; then
  export PATH=$HOME/.nodebrew/current/bin:$PATH
fi


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/kazuhiko/.sdkman"
[[ -s "/home/kazuhiko/.sdkman/bin/sdkman-init.sh" ]] && source "/home/kazuhiko/.sdkman/bin/sdkman-init.sh"
