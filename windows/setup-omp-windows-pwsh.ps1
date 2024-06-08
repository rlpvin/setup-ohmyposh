Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# WARNING
Write-Host "WARNING: This script performs the following actions." -ForegroundColor Yellow
Write-Host "Installs:"
Write-Host "`tOhMyPosh: https://github.com/JanDeDobbeleer/oh-my-posh"
Write-Host "File actions:"
Write-Host "Edits (creates if it doesn't already exist):"
Write-Host "`t$PROFILE"
Write-Host "Execute the script at your own risk."
$confirm_exec = Read-Host "Do you want to continue? (y/n)"

if ($confirm_exec -notmatch "^[Yy]$") {
    Write-Host "ERROR: Script aborted." -ForegroundColor Red
    exit 1
}

# Install OhMyPosh
winget install -h -e --id JanDeDobbeleer.OhMyPosh

# Check if $PROFILE exists
$profileDir = Split-Path -Path $PROFILE

if (-Not (Test-Path -Path $profileDir)) {
    # Create the directory and file if it doesn't exist
    New-Item -ItemType Directory -Path $profileDir -Force
    New-Item -ItemType File -Path $PROFILE -Force
}

# Add comment to $PROFILE file
Add-Content -Path $PROFILE -Value "# Added by OhMyPosh setup script."

# Activate OhMyPosh theme and add it to the config file
Add-Content -Path $PROFILE -Value "`$OMP_THEME = `"`$env:LOCALAPPDATA/Programs/oh-my-posh/themes/tokyo.omp.json`""
Add-Content -Path $PROFILE -Value "& ([ScriptBlock]::Create((oh-my-posh init pwsh --config `"`$OMP_THEME`" --print) -join `"``n`"))"

# Source the created config file in the current shell session
& $PROFILE

Write-Host "DONE: OhMyPosh has been installed and configured for PowerShell." -ForegroundColor Green
Write-Host "`nTheme tokyo.omp.json was used as the default for this script."
Write-Host "The theme can be changed by editing the value of `$OMP_THEME in the file:`n`t$PROFILE"
Write-Host "You can choose a theme from the list at https://ohmyposh.dev/docs/themes"
