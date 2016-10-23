#!/bin/bash
############################
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="themes zshrc config"       # list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$file ~/dotfiles_old/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

#oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

#packages (so, install script is based on Arch system [yaourt])
yaourt -Syyua --noconfirm && yaourt -S leafpad spotify intellij-idea-ultimate-edition terminator rofi tint2 firefox conky plank slack-desktop telegram-desktop-bin atom-editor-bin thunderbird popcorntime-bin google-chrome transmission-gtk docker compton gtk2 gtk3 feh openbox thunar xorg-xinit volumeicon lightdm jdk8-openjdk sbt scala clojure numix-circle-icon-theme-git thefuck the_silver_searcher jq ttf-inconsolata --noconfirm --needed
