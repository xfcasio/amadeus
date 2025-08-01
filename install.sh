#!/usr/bin/bash

############# DEBUG #############
# SET TO `true` TO SEE ERRORS
DEBUG=true
#################################

$DEBUG \
  && REDIRECT_TARGET='/dev/stderr' \
  || REDIRECT_TARGET='/dev/null'

{
  source helper.sh
  
  HERE="/home/$USER/amadeus"
  
  # I prefer doas
  SUDO=$(which doas 2> /dev/null)
  [ $? -eq 1 ] && SUDO=sudo
  
  HYPR_WALL="$HERE/Wallpapers/cherry-blossom.png"
  
  # NOTE: #######################################################
  #  for the bar to actually display your profile picture,      #
  #  make sure to put your JPEG profile picture in ~/.face.jpg  #
  ############################################################# #
  
  # Comment out what you need not be installed:
  dots-install::hyprland                # wm
  dots-install::wallpaper $HYPR_WALL    # installed to hyprland's default wall0.png (installed to /usr/share/hypr)
  dots-install::profile-picture         # symlink face.jpg -> ~/.face.jpg (or put your own)
  dots-install::quickshell              # install my quickshell (for bar and widgets)
# dots-install::fabric                  # isntall my fabric configuration for my bar and widgets
# dots-install::zsh                     # install my zsh configuration to ~/.zshrc
# dots-install::nushell                 # install my nushell configuration to ~/.config/nushell/
  dots-install::fish                    # install my fish configuration to ~/.config/fish/config.fish
  dots-install::neovim                  # install my neovim configuration
  dots-install::applications            # install configs for rofi, alacritty, kitty, vencord
  dots-install::neofetch                # install neofetch config
  dots-install::matrix-iamb             # my [[ personal ]] iamb configuration (edit it)
  dots-install::fonts                   # fonts I use for common software
  dots-install::fzf                     # install fzf integration for zsh (installed to ~/.fzf.zsh)
  dots-install::bins                    # some utility scripts I often use (installed to /usr/local/bin)
  dots-install::cargo-config            # install my ~/.cargo/config.toml
} 2>$REDIRECT_TARGET
