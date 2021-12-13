#!/usr/bin/env bash

CTR=$1

# exit on error
set -e

# print commands
set -x

docker create -it -v ~/.ssh:/root/.ssh:ro -p 39654:39654 -e DISPLAY=host.docker.internal:0 --name $CTR docker-iot:latest
docker start $CTR
docker exec $CTR bash -c "git clone git@github.com:rschindlauer/dotfiles.git ~/.dotfiles && cd ~/.dotfiles && rm ~/.zshrc && ./setup.sh"
docker exec $CTR nvim +PluginInstall +qall
docker exec $CTR zsh -c "cd ~/.vim/bundle/YouCompleteMe/ && python install.py; cd -"
docker stop $CTR

echo "Start container with: docker start -ia $CTR"
