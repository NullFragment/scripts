#!/bin/bash

pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd -P`
popd > /dev/null

dotfiles=(
    '.bash_aliases'
    '.tmux.conf'
    '.vimrc'
    '.zshrc'
    )

for file in ${dotfiles[@]}; do
    rm $SCRIPTPATH/dotfiles/$file &> /dev/null
done

for file in ${dotfiles[@]}; do
    cp ~/$file $SCRIPTPATH/dotfiles/
done

