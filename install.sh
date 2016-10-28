#!/bin/bash
############################
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

echo "================================================"
echo "Remember that this is really personal installer script"
echo "so please check before installing..."
echo "================================================"
echo ""
echo -n "Proceed with installation? [Y/n] "
read yes

########## Variables

dir=~/dotfiles                         # dotfiles directory
olddir=~/dotfiles_old                  # old dotfiles backup directory
files="themes zshrc config atom"       # list of files/folders to symlink in homedir

##########

function install {
  sudo pacman -S curl tar makepkg
  if hash yaourt 2>/dev/null; then
    echo "Yaourt is OK!"
  else
    # Install yaourt for AUR
    echo "Retrieving package-query ..."
    curl -O https://aur.archlinux.org/packages/pa/package-query/package-query.tar.gz
    echo "Uncompressing package-query ..."
    tar zxvf package-query.tar.gz
    cd package-query
    echo "Installing package-query ..."
    makepkg -si --noconfirm
    cd ..
    echo "Retrieving yaourt ..."
    curl -O https://aur.archlinux.org/packages/ya/yaourt/yaourt.tar.gz
    echo "Uncompressing yaourt ..."
    tar zxvf yaourt.tar.gz
    cd yaourt
    echo "Installing yaourt ..."
    makepkg -si --noconfirm
    echo "Done!"
  fi

  # Packages (so, install script is based on Arch system [yaourt])
  yaourt -Syyua --noconfirm && yaourt -S base base-devel file-roller powerline-fonts arandr pcmanfm vlc openbox-menu lxappearance lxinput scrot obmenu obconf obkey oblogout lxmenu-data leafpad spotify intellij-idea-ultimate-edition terminator rofi tint2 firefox conky plank slack-desktop telegram-desktop-bin atom-editor-bin thunderbird popcorntime-bin google-chrome transmission-gtk docker compton gtk2 gtk3 feh openbox thunar xorg-xinit volumeicon lightdm jdk8-openjdk sbt scala clojure numix-circle-icon-theme-git thefuck the_silver_searcher jq ttf-inconsolata --noconfirm --needed

  # oh-my-zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

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

  # Active zsh changes
  source ~/.zshrc

  # Firefox Extensions
  # -> AdBlocker
  # -> Developer Tools - toolbar button
  # -> Firebug
  # -> FireStorage Plus
  # -> Grammarly
  # -> S3.Google Translator
  # -> Screengrab
  # -> Send to Kindle
  # -> VimFx
  wget https://addons.mozilla.org/firefox/downloads/latest/adblocker-ultimate/addon-686646-latest.xpi && wget https://addons.mozilla.org/firefox/downloads/latest/grammarly-1/addon-566314-latest.xpi && wget https://addons.mozilla.org/firefox/downloads/latest/firebug/addon-1843-latest.xpi && wget https://addons.mozilla.org/firefox/downloads/latest/web-developer-tools-/addon-353054-latest.xpi && wget https://addons.mozilla.org/firefox/downloads/latest/firestorage-plus/addon-423470-latest.xpi && wget https://addons.mozilla.org/firefox/downloads/latest/sendtokindle/addon-399764-latest.xpi && wget https://addons.mozilla.org/firefox/downloads/latest/screengrab-fix-version/addon-355813-latest.xpi && wget https://addons.mozilla.org/firefox/downloads/latest/s3google-translator/addon-285546-latest.xpi && wget https://addons.mozilla.org/firefox/downloads/latest/vimfx/addon-404785-latest.xpi && firefox *.xpi && rm *.xpi
}

if [[ $yes == "Y" || $yes == "y" || $yes == "" ]]; then
  install
else
  echo "Exiting ..."
  exit 1
fi
