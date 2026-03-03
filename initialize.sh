sudo apt-get install ninja-build gettext cmake curl build-essential git stow
sudo apt-get install fzf
sudo app-get install ripgrep
mkdir git
cd git
git clone https://github.com/neovim/neovim
cd neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
cd ~

sudo apt-get install tmux

curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

git clone https://github.com/JeffPer/dotfiles.git
cd dotfiles

stow nvim
stow tmux

cd ~
