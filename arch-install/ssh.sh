#!/bin/bash

if ! command -v gh &> /dev/null
then
    echo "gh (GitHub CLI) could not be found, please install it first."
    exit
fi

if ! command -v ssh-keygen &> /dev/null
then
    echo "ssh-keygen could not be found, please install it first."
    exit
fi

ssh-keygen -t ed25519 -C "gustaf.silver@sweetspot.io" 

eval "$(ssh-agent -s)"
ssh-add $HOME/.ssh/id_ed25519



gh ssh-key add $HOME/.ssh/id_ed25519.pub --title "Generated key on $(date)"


chmod 400 $HOME/.ssh/id_ed25519

