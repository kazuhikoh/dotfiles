#!/bin/bash

SCRIPT_DIR=$(dirname ${BASH_SOURCE})
DOTFILES='dotfiles'

if [ -d $DOTFILES ]; then
  echo "${DOTFILES} not found!"
  exit 0
fi

echo 'Deploy dotfiles ...'

for f in .??*
do
  [[ $f = ".git" ]] && continue
  [[ $f = ".gitignore" ]] && continue
  ln -snfv $$DOTFILES/$f $HOME/$f
done

ln -s dircolors.ansi-light .dir_colors

echo 'Complete!!'
