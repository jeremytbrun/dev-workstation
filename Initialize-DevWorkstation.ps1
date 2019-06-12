#Requires -RunAsAdministrator


[cmdletbinding()]
param (
    [switch]$UACNoConsent
)

# Install Choco
Set-ExecutionPolicy Unrestricted -Force
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install all the different Choco packages I want on a box
choco install powershell pwsh googlechrome 7zip git.install vscode vscode-insiders visualstudio2019professional visualstudio2019buildtools conemu greenshot discord.install nodejs office365proplus -y

# Install the VS Code ext for syncing my settings
code-insiders --install-extension Shan.code-settings-sync
code --install-extension Shan.code-settings-sync

# Install Node packages for developing VS Code extensions
npm install -g yo generator-code vsce typescript

# Alias "pog" stands for "pretty log"
git config --global alias.pog "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Make a place for Git repos to live
New-Item -Path c:\git -ItemType Directory -Force -ErrorAction 0
Push-Location c:\git

# Show extensions for known file types; current user
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0
# Show extensions for known file types; all users
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\HideFileExt" -Name "DefaultValue" -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\HideFileExt" -Name "CheckedValue" -Value 0

# Install the PowerLine fonts that make my prompt look nifty
git clone https://github.com/powerline/fonts.git
Push-Location fonts
& .\install.ps1
Pop-Location

if ( $All -or $UACNoConsent ) {
    # Regkey to turn off UAC consent prompt behavior for Admins; NOT disabling UAC gloablly
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 0
}

# Setup PSGallery
Install-PackageProvider -Name Nuget -Scope CurrentUser -Force -Confirm:$false
Install-Module -Name Terminal-Icons -Scope CurrentUser -Repository PSGallery -Force -Confirm:$false
Import-Module Terminal-Icons -Force

# Make for a neat looking PS prompt for each profile
$profileContent = (Invoke-WebRequest https://raw.githubusercontent.com/thomasrayner/dev-workstation/master/prompt.ps1 -UseBasicParsing).Content
foreach ($proPath in @(
    "$($env:userprofile)\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    "$($env:userprofile)\Documents\PowerShell\Microsoft.VSCode_profile.ps1"
    "$($env:userprofile)\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
    "$($env:userprofile)\Documents\WindowsPowerShell\Microsoft.VSCode_profile.ps1"
)) {
    Set-Content -Value $profileContent -Path $proPath
}

