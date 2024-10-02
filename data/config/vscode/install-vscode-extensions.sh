#!/bin/bash

# Visual Studio Code :: Package list
pkglist=(
alphabotsec.vscode-eclipse-keybindings
christian-kohler.path-intellisense
eamodio.gitlens
ecmel.vscode-html-css
equinusocio.vsc-material-theme
equinusocio.vsc-material-theme-icons
ms-python.debugpy
ms-python.isort
ms-python.python
ms-python.vscode-pylance
ms-vscode-remote.remote-containers
ms-vscode-remote.remote-ssh
ms-vscode-remote.remote-ssh-edit
ms-vscode-remote.vscode-remote-extensionpack
ms-vscode.cmake-tools
ms-vscode.cpptools
ms-vscode.cpptools-extension-pack
ms-vscode.cpptools-themes
ms-vscode.remote-explorer
ms-vscode.remote-server
pkief.material-icon-theme
redhat.ansible
redhat.vscode-yaml
twxs.cmake
zainchen.json
)

for i in ${pkglist[@]}; do
  code --install-extension $i --log error --force
done
