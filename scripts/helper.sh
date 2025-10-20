dots-install::profile-picture() {
  echo "* creating profile picture symbolic link in ~/.face.jpg"
  cp "$AMADEUS_DIR/modules/user/face.jpg" "/home/$USER/.face.jpg"
}

dots-install::hyprland() {
  echo "* creating hyprland symbolic link"
  ln -fs "$AMADEUS_DIR/modules/hypr" "/home/$USER/.config/"
}

dots-install::amadeus-wallpapers() {
  echo "* cloning amadeus-wallpapers repository"
  [ -d "$AMADEUS_DIR/modules/user/Wallpapers" ] \
    && echo '└ found ~/amadeus/Wallpapers. will skip cloning.' \
    || git clone 'https://github.com/xfcasio/amadeus-wallpapers' "$AMADEUS_DIR/modules/user/Wallpapers"
}

dots-install::wallpaper() {
  echo "* creating wallpaper symlink"
  $SUDO ln -fs "$1" /usr/share/hypr/wall0.png
}

dots-install::quickshell() {
  echo "* creating quickshell symbolic link"
  ln -fs "$AMADEUS_DIR/modules/quickshell" "/home/$USER/.config/"
}

dots-install::waybar() {
  echo "* creating waybar symbolic link"
  ln -fs "$AMADEUS_DIR/modules/waybar" "/home/$USER/.config/"
}

dots-install::fabric() {
  echo "* creating fabric symbolic link"
  ln -fs "$AMADEUS_DIR/modules/fabric" "/home/$USER/.config/"
}

dots-install::neovim() {
  echo "* creating neovim symbolic link"
  ln -fs "$AMADEUS_DIR/modules/nvim" "/home/$USER/.config/"
}

dots-install::zsh() {
  echo "* creating zshrc symbolic link"
  ln -fs "$AMADEUS_DIR/modules/zshrc" "/home/$USER/.zshrc"
}

dots-install::fish() {
  echo "* creating fish symbolic link"
  mkdir -p ~/.config/fish
  ln -fs "$AMADEUS_DIR/modules/config.fish" "/home/$USER/.config/fish/"
}

dots-install::nushell() {
  echo "* creating nushell symbolic link"
  mkdir -p "/home/$USER/.config/nushell"
  ln -fs "$AMADEUS_DIR/modules/nushell/env.nu" "/home/$USER/.config/nushell/env.nu"
  ln -fs "$AMADEUS_DIR/modules/nushell/config.nu" "/home/$USER/.config/nushell/config.nu"
  ln -fs "$AMADEUS_DIR/modules/nushell/git-status.nu" "/home/$USER/.config/nushell/git-status.nu"
}

dots-install::zellij () {
  echo "* creating zellij symbolic link"
  mkdir -p "/home/$USER/.config/zellij"
  ln -fs "$AMADEUS_DIR/modules/zellij/config.kdl" "/home/$USER/.config/zellij/config.kdl"
}

dots-install::kitty() {
  echo "* creating kitty term symbolic link"
  mkdir -p ~/.config/kitty
  ln -fs "$AMADEUS_DIR/modules/kitty.conf" "/home/$USER/.config/kitty/kitty.conf"
}

dots-install::alacritty() {
  echo "* creating alacritty term symbolic link"
  mkdir -p ~/.config/alacritty
  ln -fs "$AMADEUS_DIR/modules/alacritty.toml" "/home/$USER/.config/alacritty/alacritty.toml"
}

dots-install::rofi() {
  echo "* copying rofi config"
  ROFI_BANNER="$1"
  [ -z "$ROFI_BANNER" ] && {
    echo "[!] ERROR: a banner was not given to the rofi module. check how the rofi module is used in the default install.sh"
    exit 1
  }

  cp -r "$AMADEUS_DIR/modules/rofi" "/home/$USER/.config/"
  sed -i "s|ROFI_MODULE_SHOULD_HANDLE_THIS|$ROFI_BANNER|g" ~/.config/rofi/config.rasi
}

dots-install::vencord() {
  echo "* copying rofi config"
  mkdir -p ~/.config/Vencord/themes
  ln -fs "$AMADEUS_DIR/modules/Vencord/themes/midnight-darker.theme.css" "/home/$USER/.config/Vencord/themes/midnight-darker.theme.css"
}

dots-install::neofetch() {
  echo "* creating neofetch symbolic link"
  ln -fs "$AMADEUS_DIR/modules/neofetch" "/home/$USER/.config/"
}

dots-install::matrix-iamb() {
  echo "* creating iamb config symbolic links"
  cp -r "$AMADEUS_DIR/modules/iamb" "/home/$USER/.config/"
}

dots-install::fonts() {
  echo "* installing fonts in /usr/share/fonts"
  $SUDO cp -r "$AMADEUS_DIR/modules/fonts/"* /usr/share/fonts
  echo "* reloading font cache"
  fc-cache -fv > /dev/null
}

dots-install::bins() {
  echo "* installing bin/* to /usr/local/bin/"
  $SUDO find "$AMADEUS_DIR/modules/bin" -type f -exec ln -fs {} /usr/local/bin/ \;
}

dots-install::cargo-config() {
  echo "* installing .cargo/config.toml to ~"
  mkdir -p ~/.cargo
  ln -fs "$AMADEUS_DIR/modules/.cargo/config.toml" "/home/$USER/.cargo/config.toml"
}

dots-install::fzf() {
  if ! command -v zsh &>/dev/null; then
    echo "[!] zsh isn't found, so can't set up fzf for it... skipping this module."
    return
  fi

  echo '* checking whether fzf is installed'

  if command -v fzf &>/dev/null; then
    [[ -f ~/.fzf.zsh ]] && return

    echo "fzf is installed but no ~/.fzf.zsh is found!"

    while true; do
      read -p "[?] Should I set it up automatically? (y/n): " answer
      case "$answer" in
        [Yy])
          echo "Generating ~/.fzf.zsh ..."
          if fzf --zsh > ~/.fzf.zsh; then
            echo '[+] Successfully set up ~/.fzf.zsh'
          else
            echo '[!] Failed to generate ~/.fzf.zsh'
          fi
          break
          ;;
        [Nn])
          echo "Skipping..."
          break
          ;;
        *)
          echo "Invalid option. Please pick either 'y' or 'n'."
          ;;
      esac
    done
  else
    echo ">>> fzf is not installed, fzf+zsh shell autocompletion will be missing."
  fi
}
