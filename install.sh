#!/usr/bin/bash

############# DEBUG #############
# SET TO `true` TO SEE ERRORS
DEBUG=true
#################################

$DEBUG \
  && REDIRECT_TARGET='/dev/stderr' \
  || REDIRECT_TARGET='/dev/null'

{
  AMADEUS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  
  source "$AMADEUS_DIR/scripts/helper.sh"
  
  # I prefer doas
  SUDO=$(which doas 2> /dev/null)
  [ $? -eq 1 ] && SUDO=sudo
  
  HYPR_WALL="$AMADEUS_DIR/modules/user/Wallpapers/nord_beach.png"
  ROFI_BANNER="$AMADEUS_DIR/modules/user/Wallpapers/nord_beach.png"
  
  # NOTE: #######################################################
  #  * for the bar to actually display your profile             #
  #    picture, make sure to put your JPEG profile              #
  #    picture in ~/.face.jpg                                   #
  ###############################################################
  
  # Comment out what you need not be installed:
  dots-install::hyprland                # wm
  dots-install::amadeus-wallpapers      # clone amadeus-wallpapers repository to $AMADEUS_DIR/modules/user/Wallpapers
  dots-install::wallpaper $HYPR_WALL    # installed to hyprland's default wall0.png (in /usr/share/hypr)
  dots-install::profile-picture         # symlink (default) face.jpg -> ~/.face.jpg (comment this module out if you'll put your own in ~/.face.jpg)
  dots-install::quickshell              # install quickshell (for bar and widgets)
# dots-install::fabric                  # isntall fabric configuration for my bar and widgets
# dots-install::zsh                     # install zsh configuration to ~/.zshrc
# dots-install::nushell                 # install nushell configuration to ~/.config/nushell/
  dots-install::fish                    # install fish configuration to ~/.config/fish/config.fish
  dots-install::zellij                  # install zellij configuration to ~/.config/zellij/config.kdl
  dots-install::neovim                  # install neovim configuration
  dots-install::rofi $ROFI_BANNER       # install rofi configuration
  dots-install::alacritty               # install alacritty configuration
#  dots-install::kitty                  # install kitty configuration
  dots-install::vencord                 # install vencord configuration
  dots-install::neofetch                # install neofetch config
  dots-install::fonts                   # fonts for common software
  dots-install::fzf                     # install fzf integration for zsh (installed to ~/.fzf.zsh)
  dots-install::bins                    # some utility scripts I often use (installed to /usr/local/bin)
# dots-install::cargo-config            # install my ~/.cargo/config.toml (you should probably opt out of this)
} 2>$REDIRECT_TARGET
