#!/usr/bin/env bash
set -eo pipefail

# WARNING
echo -e "WARNING: This script performs the following actions.\nInstalls:\n\tHomebrew: https://github.com/Homebrew/homebrew-core\n\tOhMyPosh: https://github.com/JanDeDobbeleer/oh-my-posh\nFile actions:\nCreates:\n\t$HOME/.omp_bash\nEdits (one of the following): \n\t$HOME/.profile\n\t$HOME/.bash_profile\n\t$HOME/.bashrc\nExecute the script at your own risk."
echo -n "Do you want to continue? (y/n): "
read -r confirm_exec

if [[ ! "$confirm_exec" =~ ^[Yy]$ ]]; then
  echo "ERROR: Script aborted."
  exit 1
fi

# Create new config file for OhMyPosh to avoid polluting the default config file
touch ~/.omp_bash

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
    echo "export PATH=\"$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH\"" >>~/.omp_bash
    export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"
  fi
fi

# Install OhMyPosh
brew install oh-my-posh

# Activate OhMyPosh theme and add it to the config file
echo "export OMP_THEME=\"\$(brew --prefix oh-my-posh)/themes/tokyo.omp.json\"" >>~/.omp_bash
echo "eval \"\$(oh-my-posh init $(oh-my-posh get shell) -c \$OMP_THEME)\"" >>~/.omp_bash

# Source the created config file in the default shell config file
[[ -f "$HOME/.bashrc" ]] && BASH_CONF="$HOME/.bashrc"
[[ -f "$HOME/.bash_profile" ]] && BASH_CONF="$HOME/.bash_profile"
[[ -f "$HOME/.profile" ]] && BASH_CONF="$HOME/.profile"

if [[ -n "$BASH_CONF" ]]; then
  echo -e "\n# Added by OhMyPosh setup script" >>"$BASH_CONF"
  echo "source ~/.omp_bash" >>"$BASH_CONF"
else
  echo -e "WARN: Could not find a typical bash config file. You can add the following line manually to your bash config that is sourced every time you start a shell session.\n\n\tsource ~/.omp_bash"
fi

# Source the created config file in the current shell session
if [[ -f "$HOME/.omp_bash" ]]; then
  source "$HOME/.omp_bash"
else
  echo "Unable to source file ~/.omp_bash. Run the following command to source it manually:"
  echo -e "\tsource ~/.omp_bash"
fi

echo -e "DONE: OhMyPosh has been installed and configured for bash.\n\nTheme tokyo.omp.json was used as the default for this script.\nThe theme can be changed by editing the value of \$OMP_THEME in the $HOME/.omp_bash file.\nYou can choose a theme from the list at https://ohmyposh.dev/docs/themes"
