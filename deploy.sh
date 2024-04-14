#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR

# Link dotfiles
for f in .??*
do
  [[ $f = ".git" ]] && continue
  [[ $f = ".gitignore" ]] && continue
  [[ $f = ".config" ]] && continue

  ln -svf $SCRIPT_DIR/$f $HOME/$f
done

# Link .config/*
[[ ! -e $HOME/.config ]] && mkdir $HOME/.config
for dir in .config/*
do
  ln -svf $SCRIPT_DIR/$dir $HOME/$dir
done

# Link bin/
[[ ! -e $HOME/bin ]] && ln -svf $SCRIPT_DIR/bin $HOME/bin

ln -svf $SCRIPT_DIR/dircolors/dircolors.ansi-light $HOME/.dir_colors

