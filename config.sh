#! /usr/bin/env sh
rm -f ~/.gitconfig
rm -f ~/.bashrc
rm -f ~/.bash_profile
rm -f ~/.vimrc
rm -rf ~/.vim/bundle/vundle
ln -s $PWD/.gitconfig ~/.gitconfig
ln -s $PWD/.bashrc ~/.bashrc
ln -s ~/.bashrc ~/.bash_profile
ln -s $PWD/.vimrc ~/.vimrc
ln -s $PWD/.vim/bundle/vundle ~/.vim/bundle/vundle
