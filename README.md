
<p align="center">
    <img src="https://user-images.githubusercontent.com/87579883/211211879-36bc3b05-23a7-4623-bf0d-cc59339e1d84.png" alt="logo" width="200"/>
</p>
<h1 align="center" style="margin-top: 0px;">Apple Flake</h1>
<p align="center" >MacBook Pro M1 Nix configuration based on flake</p>

<div align="center" >

[![Built with nix](https://builtwithnix.org/badge.svg)]

</div>

My nix configurations on work's MacBook

## Hosts

A brief description about each hosts managed by this flake

### Aron

This is the MacOs itself. Currently only a part of the System
configuration is under Nix (Dock and other stuff aren't for example).
It uses Nix and Homebrew, and homebrew is managed by nix itself, so
it's atleast a bit reproducible.

Currently the configuration is splitted in multiple pkgs, but they're
not modules used across multiple machines (yet).

### Fnord

This is a VM, deployed using VMWare Fusion, following the examples by
[Hashimoto](https://github.com/mitchellh/nixos-config/tree/main)

The Makefile is almost 1:1 with his Makefile, and it handles the VM boostrap.

## Deploy

Actually is far from an ideal setup, and the deploy part is the most
basic possible.

Darwin Host:
`darwin-rebuild switch --flake '.#aron'`

Linux Host:
`nixos-rebuild --build-host fnord --target-host fnord --fast --impure --flake .#fnord switch`

The above command will build the configuration directly in the VM host
(needed as the host is an aarch64-darwin)
