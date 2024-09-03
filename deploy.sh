#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR

readonly BACKUP_TIMESTAMP="$(date '+%Y%m%d%H%M%S')"

# Link dotfiles
for f in .??*
do
  [[ $f = ".git" ]] && continue
  [[ $f = ".gitignore" ]] && continue
  [[ $f = ".config" ]] && continue
  [[ $f = ".vim" ]] && continue

  ln -svf $SCRIPT_DIR/$f $HOME/$f
done

# Link .config/*
[[ ! -e $HOME/.config ]] && mkdir $HOME/.config
for it in .config/*
do
  [[ -L $HOME/$it ]] && continue
  [[ -e $HOME/$it ]] && {
    bk="$HOME/${it}_${BACKUP_TIMESTAMP}"
    echo "backup: $HOME/$it -> $bk" 
    mv $HOME/$it $bk
  }
  ln -svf $SCRIPT_DIR/$it $HOME/$it
done

# Link .vim/*
[[ ! -e $HOME/.vim ]] && mkdir $HOME/.vim
for it in .vim/*
do
  [[ -L $HOME/$it ]] && continue
  [[ -e $HOME/$it ]] && {
    bk="$HOME/${it}_${BACKUP_TIMESTAMP}"
    echo "backup: $HOME/$it -> $bk"
    mv $HOME/$it $bk  
  }
  ln -svf $SCRIPT_DIR/$it $HOME/$it
  # => $HOME/.vim/vimrc --> $SCRIPT_DIR/.vim/vimrc
done

# Link bin/
[[ ! -e $HOME/bin ]] && ln -svf $SCRIPT_DIR/bin $HOME/bin

ln -svf $SCRIPT_DIR/dircolors/dircolors.ansi-light $HOME/.dir_colors

