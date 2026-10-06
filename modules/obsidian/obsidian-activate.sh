#!/usr/bin/env bash
# Obsidian Nix Activation Script
# Applies settings from obsidian.nix to ~/.obsidian/

set -euo pipefail

# Find obsidian.nix
if [[ $# -gt 0 ]]; then
  NIX_FILE="$1"
else
  # Try common locations
  if [[ -f "$HOME/dotfiles/obsidian.nix" ]]; then
    NIX_FILE="$HOME/dotfiles/obsidian.nix"
  elif [[ -f "/etc/obsidian.nix" ]]; then
    NIX_FILE="/etc/obsidian.nix"
  elif [[ -f "./obsidian.nix" ]]; then
    NIX_FILE="./obsidian.nix"
  else
    echo "Error: obsidian.nix not found"
    echo "Usage: obsidian-activate.sh [path/to/obsidian.nix]"
    exit 1
  fi
fi

if [[ ! -f "$NIX_FILE" ]]; then
  echo "Error: File not found: $NIX_FILE"
  exit 1
fi

OBSIDIAN_CONFIG="$HOME/.obsidian"
mkdir -p "$OBSIDIAN_CONFIG"

echo "Applying Obsidian settings from: $NIX_FILE"

# Evaluate Nix file to JSON using nix eval
if ! command -v nix &> /dev/null; then
  echo "Error: nix not found. Required for parsing obsidian.nix"
  exit 1
fi

# Extract config and plugins from Nix file
eval_output=$(nix eval --json --impure --expr "import \"$NIX_FILE\"" 2>/dev/null || true)

if [[ -z "$eval_output" ]]; then
  echo "Error: Failed to evaluate Nix file"
  echo "Make sure it's valid Nix syntax and nix is installed"
  exit 1
fi

# Write config files
echo "$eval_output" | jq -r '.config | to_entries[] | "\(.key) \(.value | @json)"' | while read key value; do
  echo "$value" | jq . > "$OBSIDIAN_CONFIG/${key}.json"
  echo "  ✓ Applied ${key}.json"
done

# Write plugin files
mkdir -p "$OBSIDIAN_CONFIG/plugins"
echo "$eval_output" | jq -r '.plugins | to_entries[] | "\(.key) \(.value | @json)"' | while read pluginId pluginData; do
  PLUGIN_DIR="$OBSIDIAN_CONFIG/plugins/$pluginId"
  mkdir -p "$PLUGIN_DIR"

  # Write manifest
  echo "$pluginData" | jq '.manifest' > "$PLUGIN_DIR/manifest.json"
  echo "Applied plugins/${pluginId}/manifest.json"

  # Write settings if not null
  if [[ $(echo "$pluginData" | jq '.settings | type') != "null" ]]; then
    echo "$pluginData" | jq '.settings' > "$PLUGIN_DIR/data.json"
    echo "Applied plugins/${pluginId}/data.json"
  fi
done

echo "Obsidian settings restored successfully!"
echo "Restart Obsidian to apply changes."
