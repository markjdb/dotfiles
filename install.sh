#!/bin/sh

for file in screenrc vimrc gitconfig bashrc muttrc; do
    install $file ${HOME}/.${file}
done
