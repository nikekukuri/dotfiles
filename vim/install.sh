#!/bin/bash
path=~/.vim
nvim_path=~/.config/nvim

if [ ! -e $path ]; then
  mkdir -p $path
fi

if [ ! -e ~/.config/nvim ]; then
  mkdir -p $nvim_path
fi

if [[ ! -e $HOME/.vimrc ]]; then
  ln -s $PWD/vimrc $HOME/.vimrc
fi

if [[ ! -e $nvim_path/init.lua ]]; then
  ln -s $PWD/init.lua $nvim_path/init.lua
fi

if [[ ! -e $nvim_path/lua ]]; then
  ln -s $PWD/lua $nvim_path/lua
fi
