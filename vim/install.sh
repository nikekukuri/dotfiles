#!/bin/bash
path=~/.vim
nvim_path=$XDG_CONFIG_HOME/nvim

if [ ! -e $path ]; then
  mkdir -p $path
fi

if [ ! -e $XDG_CONFIG_HOME/nvim ]; then
  mkdir -p $nvim_path
fi

if [[ ! -e $HOME/.vimrc ]]; then
  ln -s $PWD/vimrc $HOME/.vimrc
fi
