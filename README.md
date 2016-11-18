# LibreELEC updater
Updater for the current [LibreELEC](https://libreelec.tv/) Alpha (Krypton).

## Requirements
- curl
- ssh

## Setup
The script expects your ssh-config to contain an entry `elec` that can access
your LibreELEC with an ssh-key. If your setup is different, set the variable
`SSH` in `update-kodi.sh` and `update-amazon.sh` accordingly.

## Issues
`update-amazon.sh` has no version checks.
