#!/usr/bin/env bash
set -eo pipefail

# Setting script variables
CURRENT_SHELL=$(basename "$(ps -p $PPID -o comm=)")
OMP_INIT_CMD="eval \"\$(oh-my-posh init \$(oh-my-posh get shell) -c \$OMP_THEME)\""
CONFIG_FILE="$HOME/.omp_init"

# Get OMP and shell config files
if [[ "$CURRENT_SHELL" == "zsh" ]]; then
  SHELL_RC="$HOME/.zshrc"
elif [[ "$CURRENT_SHELL" == "bash" ]]; then
  [[ -f "$HOME/.bashrc" ]] && SHELL_RC="$HOME/.bashrc"
  [[ -f "$HOME/.bash_profile" ]] && SHELL_RC="$HOME/.bash_profile"
  [[ -f "$HOME/.profile" ]] && SHELL_RC="$HOME/.profile"
else
  echo "Unsupported shell: $CURRENT_SHELL. This script only supports bash and zsh."
  exit 2
fi

# WARNING
echo -e "WARNING: This script performs the following actions."
echo -e "Installs:"
echo -e "\tHomebrew:"
echo -e "\t\thttps://github.com/Homebrew/homebrew-core"
echo -e "\t\thttps://brew.sh"
echo -e "\tOhMyPosh:"
echo -e "\t\thttps://github.com/JanDeDobbeleer/oh-my-posh"
echo -e "\t\thttps://ohmyposh.dev"
echo -e "File actions:"
echo -e "\tCreates:"
echo -e "\t$CONFIG_FILE"
echo -e "Edits:"
echo -e "\t$SHELL_RC"
echo -e "Execute the script at your own risk."
echo -n "Do you wish to continue? (y/n): "
read -r confirm_exec

if [[ ! "$confirm_exec" =~ ^[Yy]$ ]]; then
  echo "ERROR: Script aborted."
  exit 1
fi

# Create new config file for OhMyPosh if it doesn't already exist to avoid polluting the default config file
if [[ ! -f $CONFIG_FILE ]]; then
  touch "$CONFIG_FILE"
else
  echo "Not creating $CONFIG_FILE, file already exists."
fi

# Add comment to shell config file
echo -e "\n# Added by OhMyPosh setup script" >>"$SHELL_RC"

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
  if ! command -v brew &>/dev/null; then
    # Add Homebrew to PATH if not already added
    NEW_PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:\$PATH"
    echo "export PATH=\"$NEW_PATH\"" >>"$SHELL_RC"
    export PATH="$NEW_PATH"
  fi

  echo "Homebrew installed successfully."
fi

# Install OhMyPosh
brew install oh-my-posh

# Activate OhMyPosh theme and add it to the config file
echo "export OMP_THEME=\"\$(brew --prefix oh-my-posh)/themes/tokyo.omp.json\"" >>"$CONFIG_FILE"
echo "$OMP_INIT_CMD" >>"$CONFIG_FILE"

# Source the created config file in the default shell config file
if [[ -n "$SHELL_RC" && -f "$SHELL_RC" ]]; then
  echo "source $CONFIG_FILE" >>"$SHELL_RC"
else
  echo -e "WARN: Could not find a typical shell config file. You can add the following line manually to your shell config that is sourced every time you start a shell session.\n\n\tsource $CONFIG_FILE"
fi

# Source the created config file in the current shell session
if [[ -f "$CONFIG_FILE" ]]; then
  source "$CONFIG_FILE"
else
  echo "Unable to source file $CONFIG_FILE. Run the following command to source it manually:"
  echo -e "\tsource $CONFIG_FILE"
fi

echo -e "DONE: OhMyPosh has been installed and configured for $CURRENT_SHELL.\n\nTheme tokyo.omp.json was used as the default for this script.\nThe theme can be changed by editing the value of \$OMP_THEME in the $CONFIG_FILE file.\nYou can choose a theme from the list at https://ohmyposh.dev/docs/themes"
