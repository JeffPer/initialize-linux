#!/usr/bin/env sh
set -eu

DOTFILES_REPOSITORY="https://github.com/JeffPer/dotfiles.git"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dev/dotfiles}"
NEOVIM_DIR="${NEOVIM_DIR:-$HOME/git/neovim}"

link_dotfile() {
  source_path=$1
  target_path=$2

  if [ -e "$target_path" ] && [ ! -L "$target_path" ]; then
    printf 'Refusing to replace existing path: %s\n' "$target_path" >&2
    exit 1
  fi

  ln -sfn "$source_path" "$target_path"
}

sudo apt-get update
sudo apt-get install -y ninja-build gettext cmake curl build-essential git fzf ripgrep tmux

if [ ! -d "$NEOVIM_DIR/.git" ]; then
  if [ -e "$NEOVIM_DIR" ]; then
    printf 'Refusing to replace existing path: %s\n' "$NEOVIM_DIR" >&2
    exit 1
  fi
  mkdir -p "$(dirname "$NEOVIM_DIR")"
  git clone https://github.com/neovim/neovim "$NEOVIM_DIR"
fi

make -C "$NEOVIM_DIR" CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make -C "$NEOVIM_DIR" install

if [ ! -d "$DOTFILES_DIR/.git" ]; then
  if [ -e "$DOTFILES_DIR" ]; then
    printf 'Refusing to replace existing path: %s\n' "$DOTFILES_DIR" >&2
    exit 1
  fi
  mkdir -p "$(dirname "$DOTFILES_DIR")"
  git clone "$DOTFILES_REPOSITORY" "$DOTFILES_DIR"
fi

if [ -L "$HOME/.config" ]; then
  printf '%s must be a directory, not a symlink. Refusing to modify it.\n' "$HOME/.config" >&2
  exit 1
fi

mkdir -p "$HOME/.config"
link_dotfile "$DOTFILES_DIR/nvim/.config/nvim" "$HOME/.config/nvim"
link_dotfile "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
