#!/usr/bin/env zsh
set -eo pipefail

# WARNING
echo -e "WARNING: This script performs the following actions.\nInstalls:\n\tHomebrew: https://github.com/Homebrew/homebrew-core\n\tOhMyPosh: https://github.com/JanDeDobbeleer/oh-my-posh\nFile actions:\nCreates:\n\t$HOME/.omp_zsh\nEdits:\n\t$HOME/.zshrc\nExecute the script at your own risk."
echo -n "Do you want to continue? (y/n): "
read -r confirm_exec

if [[ ! "$confirm_exec" =~ ^[Yy]$ ]]; then
  echo "ERROR: Script aborted."
  exit 1
fi

# Create new config file for OhMyPosh to avoid polluting the default config file
touch ~/.omp_zsh

# Check if Homebrew is installed
if command -v brew &>/dev/null; then
  echo "Homebrew is already installed."
else
  # Install Homebrew
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Determine Homebrew prefix path based on architecture (for macOS)
  if [[ "$(uname)" == "Darwin" ]]; then
    if [[ "$(uname -m)" == "arm64" ]]; then
      HOMEBREW_PREFIX="/opt/homebrew"
    else
      HOMEBREW_PREFIX="/usr/local"
    fi
  else
    # Linux default Homebrew prefix is typically /home/linuxbrew/.linuxbrew
    HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
  fi

  # Check if Homebrew was installed and added to PATH successfully
  if command -v brew &>/dev/null; then
    echo "Homebrew installed successfully."
  else
    # Add Homebrew to PATH if not already added
    echo "export PATH=\"$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH\"" >>~/.omp_zsh
    export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"
  fi
fi

# Install OhMyPosh
brew install oh-my-posh

# Activate OhMyPosh theme and add it to the config file
echo "export OMP_THEME=\"\$(brew --prefix oh-my-posh)/themes/tokyo.omp.json\"" >>~/.omp_zsh
echo "eval \"\$(oh-my-posh init $(oh-my-posh get shell) -c \$OMP_THEME)\"" >>~/.omp_zsh

# Source the created config file in the default shell config file
if [[ -f "$HOME/.zshrc" ]]; then
  echo -e "\n# Added by OhMyPosh setup script"
  echo "source ~/.omp_zsh" >>~/.zshrc
else
  echo "~/.zshrc file not found. You can create/edit it manually to add the following command:"
  echo -e "\tsource ~/.omp_zsh"
fi

# Source the created config file in the current shell session
if [[ -f "$HOME/.omp_zsh" ]]; then
  source "$HOME/.omp_zsh"
else
  echo "Unable to source file ~/.omp_zsh. Run the following command to source it manually:"
  echo -e "\tsource ~/.omp_zsh"
fi

echo -e "DONE: OhMyPosh has been installed and configured for zsh.\n\nTheme tokyo.omp.json was used as the default for this script.\nThe theme can be changed by editing the value of \$OMP_THEME in the $HOME/.omp_zsh file.\nYou can choose a theme from the list at https://ohmyposh.dev/docs/themes"
