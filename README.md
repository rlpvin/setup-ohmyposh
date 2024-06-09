# Setup OhMyPosh

## Table of Contents
- [Setup OhMyPosh](#setup-ohmyposh)
  - [Table of Contents](#table-of-contents)
  - [What is OhMyPosh?](#what-is-ohmyposh)
  - [What is this repo?](#what-is-this-repo)
  - [Before running](#before-running)
  - [Prerequisites](#prerequisites)
  - [Usage](#usage)
    - [macOS / Linux](#macos--linux)
      - [zsh, bash](#zsh-bash)
      - [pwsh (PowerShell)](#pwsh-powershell)
    - [Windows](#windows)
      - [PowerShell](#powershell)
  - [Troubleshooting](#troubleshooting)
  - [Additional information](#additional-information)
    - [Tested on](#tested-on)
    - [Nerd Fonts](#nerd-fonts)

## What is OhMyPosh?

[OhMyPosh](https://ohmyposh.dev/) by JanDeDobbeleer is a highly customizable, cross-platform shell prompt renderer that lets you add useful integrations to your shell prompts (Git, GCP, project info, and a lot more).

## What is this repo?

This repo just contains shell scripts to automate the installation and setup of OhMyPosh for macOS, Windows, and Linux.

## Before running

**Note**: These scripts are not written by or officially recommended by OhMyPosh. I wrote them for personal use, and wanted to share them. You are free to use them. Make sure to review the code before you run it on your system.

All scripts use the **tokyo.omp.json** theme as the default. The theme can be changed later to a theme of your choice (one from the themes that come with OMP or a custom theme) by editing the $OMP_THEME variable.

## Prerequisites

+ **curl** or **wget** for unix (macOS / Linux) scripts

## Usage

The scripts can be accessed using the raw links to the files.

**Ensure you are running the scripts in the intended shell.**

### macOS / Linux

All scripts for macOS and Linux use [Homebrew](https://brew.sh) to install OhMyPosh and will install Homebrew if it is not already installed.

#### zsh, bash

Run the script:

**curl**:

```sh
"$(ps -p $$ -o comm=)" -c "$(curl -fsSL https://raw.githubusercontent.com/rlpvin/setup-ohmyposh/main/unix/setup-omp-unix.sh)"
```

**wget**:

```sh
"$(ps -p $$ -o comm=)" -c "$(wget -qO- https://raw.githubusercontent.com/rlpvin/setup-ohmyposh/main/unix/setup-omp-unix.sh)"
```

#### pwsh (PowerShell)

Run the script:

```powershell
Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/rlpvin/setup-ohmyposh/main/unix/setup-omp-unix-pwsh.ps1").Content
```

### Windows

The Windows version of the script uses **winget** to install OhMyPosh.

#### PowerShell

Run the script:

```powershell
Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/rlpvin/setup-ohmyposh/main/unix/setup-omp-windows-pwsh.ps1").Content
```

## Troubleshooting

+ If the script runs successfully but the prompt doesn't change, try sourcing the OMP config file created by the script or your shell config file:

```sh
source ~/.omp_init
```

or (example: zsh):

```sh
source ~/.zshrc
```

+ If the script is unable to locate your shell config file, add this line manually to it:

```sh
source ~/.omp_init
```

## Additional information

### Tested on

+ Windows 11
+ macOS Sonoma 14.5 (Apple Silicon)
+ Ubuntu (WSL)

### Nerd Fonts

It is recommended to use a [Nerd Fonts](https://www.nerdfonts.com) font in your terminal emulator to display additional icons, such as: logos, in some OhMyPosh themes. You can download these [here](https://www.nerdfonts.com/font-downloads?ref=itsfoss.com).

You can also install Nerd Fonts using Homebrew:

```sh
# List all available Nerd Fonts
brew search nerd-font

# Install a font you like
brew install font-fira-code-nerd-font
```
