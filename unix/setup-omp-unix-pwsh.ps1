#!/usr/bin/env pwsh
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# WARNING
Write-Host "WARNING: This script performs the following actions." -ForegroundColor Yellow
Write-Host "Installs:"
Write-Host "`tHomebrew: https://github.com/Homebrew/homebrew-core"
Write-Host "`tOhMyPosh: https://github.com/JanDeDobbeleer/oh-my-posh"
Write-Host "File actions:"
Write-Host "Edits:"
Write-Host "PowerShell: $PROFILE"
Write-Host "Execute the script at your own risk."
$confirm_exec = Read-Host "Do you want to continue? (y/n)"

if ($confirm_exec -notmatch "^[Yy]$") {
    Write-Host "ERROR: Script aborted." -ForegroundColor Red
    exit 1
}

# Check if $PROFILE exists
$profileDir = Split-Path -Path $PROFILE

if (-Not (Test-Path -Path $profileDir)) {
    # Create the directory and file if it doesn't exist
    New-Item -ItemType Directory -Path $profileDir -Force
    New-Item -ItemType File -Path $PROFILE -Force
}

# Add comment to $PROFILE file
Add-Content -Path $PROFILE -Value "# Added by OhMyPosh setup script."

# Check if Homebrew is installed
if (Get-Command brew -ErrorAction SilentlyContinue) {
    Write-Host "Homebrew is already installed."
} else {
    # Install Homebrew
    Write-Host "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Determine Homebrew prefix path based on architecture (for macOS)
    if ($IsMacOS) {
        if ((uname -m) -eq "arm64") {
            $HOMEBREW_PREFIX = "/opt/homebrew"
        } else {
            $HOMEBREW_PREFIX = "/usr/local"
        }
    } else {
        # Linux default Homebrew prefix is typically /home/linuxbrew/.linuxbrew
        $HOMEBREW_PREFIX = "/home/linuxbrew/.linuxbrew"
    }

    # Check if Homebrew was installed and added to PATH successfully
    if (Get-Command brew -ErrorAction SilentlyContinue) {
        Write-Host "Homebrew installed successfully."
    } else {
        # Add Homebrew to PATH if not already added
        Add-Content -Path $PROFILE -Value "`$env:PATH += `":$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin`""
        $env:PATH += ":$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin"
    }
}

# Install OhMyPosh
brew install oh-my-posh

# Activate OhMyPosh theme and add it to the config file
Add-Content -Path $PROFILE -Value "`$OMP_THEME = `"`$(brew --prefix oh-my-posh)/themes/tokyo.omp.json`""
Add-Content -Path $PROFILE -Value "(@(& `'/opt/homebrew/bin/oh-my-posh`' init pwsh --config=`$OMP_THEME --print) -join `"``n`") | Invoke-Expression"

# Source the created config file in the current shell session
~/.config/powershell/Microsoft.PowerShell_profile.ps1

Write-Host "DONE: OhMyPosh has been installed and configured for PowerShell." -ForegroundColor Green
Write-Host "`nTheme tokyo.omp.json was used as the default for this script."
Write-Host "The theme can be changed by editing the value of `$OMP_THEME in the file:`n`t$PROFILE"
Write-Host "You can choose a theme from the list at https://ohmyposh.dev/docs/themes"
