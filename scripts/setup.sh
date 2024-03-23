#!/bin/bash
set -e
sudo usermod -a -G video,audio,wheel wasd

wget https://mirror.cachyos.org/cachyos-repo.tar.xz
tar xvf cachyos-repo.tar.xz && cd cachyos-repo
sudo ./cachyos-repo.sh
cd ..

sudo pacman -Syu --needed base-devel mold sccache reflector python ccache neovim lld paru rustup

sudo cp -r ~/dotfiles/system/makepkg.conf /etc/makepkg.conf

rustup default nightly
