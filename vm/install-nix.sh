#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install curl

sh <(curl -L https://nixos.org/nix/install) --daemon

sudo bash -c "echo 'experimental-features = nix-command flakes' >> /etc/nix/nix.conf"
