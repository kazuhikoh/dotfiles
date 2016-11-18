# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# prompt
PROMPT='%F{blue}%n@%m%# %f'
#PROMPT2=
#SPROMPT=
#RPROMPT=

# aliases
alias ls='ls --color=auto'
alias ll='ls -alF --color=auto'
alias grep='grep --color=auto'

# cygwin
if [ -f "${HOME}/.shrc_cygwin" ]; then
  source "${HOME}/.shrc_cygwin"
fi

# extra
if [ -f "${HOME}/.shrc_extra" ]; then
  source "${HOME}/.shrc_extra"
fi
