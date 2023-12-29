# Arch Linux Install

Boot the Ach Linux installation media and run
```bash
curl -LO https://raw.githubusercontent.com/cl4irv0yant/dotfiles/master/arch-linux/install.sh
bash install.sh
```
TODO: Add nvidia-dkms hyprland support (env variables, mkinitcpio, grub, linux-headers) https://wiki.hyprland.org/Nvidia/
TODO: sudo systemctl --user enable syncthing.service && sudo systemctl --user start syncthing.service
TODO: sudo systemctl enable tailscaled && sudo systemctl start tailscaled
TODO: sudo systemctl enable bluetooth.service && sudo systemctl start bluetooth.service
TODO: sudo systemctl enable mpd.servie && sudo systemctl start mpd.service
TODO: sudo systemctl enable docker.service && sudo systemctl start docker.service
TODO: zfs mount, import and symlink
TODO: git remote set-url origin git@github.com:cl4irv0yant/dotfiles.git  


Interesting idea:

NAME:
   syncthing cli - Syncthing command line interface

USAGE:
   syncthing cli command [command options] [arguments...]

COMMANDS:
   config      Configuration modification command group
   show        Show command group
   operations  Operation command group
   errors      Error command group
   debug       Debug command group
   -           Read commands from stdin

OPTIONS:
   --gui-address URL     Override GUI address to URL (e.g. "192.0.2.42:8443")
   --gui-apikey API-KEY  Override GUI API key to API-KEY
   --home PATH           Set configuration and data directory to PATH
   --config PATH         Set configuration directory (config and keys) to PATH
   --data PATH           Set data directory (database and logs) to PATH
   --help, -h            show help

