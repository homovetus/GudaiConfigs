﻿#!/usr/bin/env pwsh
param (
    [switch]$Debug = $false
)

$UserDir = if ($IsMacOS) { "$env:HOME" } else { "$env:USERPROFILE" }

function CreateSymbolicLink {
    param (
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Target,
        [Parameter(Mandatory = $false)][string]$ConfigDir = (Get-Location).Path
    )

    $Path = [IO.Path]::GetFullPath($Path)
    $Target = [IO.Path]::GetFullPath((Join-Path $ConfigDir $Target))

    if ($Debug) {
        Write-Host "Will be linking: $Path -> $Target" -ForegroundColor Green
    }
    else {
        New-Item -ItemType SymbolicLink -Path $Path -Target $Target -Force | Out-Null
        Write-Host "Linked $Path -> $Target" -ForegroundColor Green
    }
}

function CopySSHKeys {
    param (
        [Parameter(Mandatory = $true)][string]$Target
    )

    # Get the file name from the path
    $FileName = Split-Path $Target -Leaf
    $Path = [IO.Path]::GetFullPath("$UserDir/.ssh/$FileName")
    $Target = [IO.Path]::GetFullPath($Target)

    if ($Debug) {
        Write-Host "Will be copying: $Target -> $Path" -ForegroundColor Yellow
    }
    else {
        Copy-Item $Target $Path -Force
        Write-Host "Copied $Target -> $Path" -ForegroundColor Yellow
    }
}


# Common Files
Write-Host "Files for all platform:" -ForegroundColor Magenta
CreateSymbolicLink "$UserDir/.vimrc" ".vimrc"
CreateSymbolicLink "$UserDir/.ideavimrc" ".ideavimrc"
CreateSymbolicLink "$UserDir/.config" ".config"
CreateSymbolicLink "$UserDir/.gitconfig" ".gitconfig"
CreateSymbolicLink "$UserDir/.ssh/config" "SSHConfig"
Write-Host ""

# Mac Files
if ($IsMacOS) {
    Write-Host "Files for Mac:" -ForegroundColor Magenta
    CreateSymbolicLink "$UserDir/.zshrc" ".zshrc"

    CopySSHKeys "$UserDir/Google Drive/My Drive/Backup/SSHKeys/homovetus"
    CopySSHKeys "$UserDir/Google Drive/My Drive/Backup/SSHKeys/homovetus.pub"
}
else {
    $OneDrive = "$env:OneDrive/Backups"

    Write-Host "Files for Windows:" -ForegroundColor Magenta
    CreateSymbolicLink "$UserDir/Documents/PowerShell" ".config/powershell"
    CreateSymbolicLink "$UserDir/Documents/PowerToys" "PowerToys"
    CreateSymbolicLink "$env:LOCALAPPDATA/nvim" ".config/nvim"
    CreateSymbolicLink "$env:LOCALAPPDATA/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json" "WindowsTerminal.json"
    CreateSymbolicLink "$env:LOCALAPPDATA/Microsoft/Windows/Themes/Gudai Dark.theme" "Gudai Dark.theme"
    CreateSymbolicLink "$env:LOCALAPPDATA/Microsoft/Windows/Themes/Gudai Light.theme" "Gudai Light.theme"

    CopySSHKeys "$OneDrive/SSHKeys/homovetus"
    CopySSHKeys "$OneDrive/SSHKeys/homovetus.pub"

    CreateSymbolicLink "$UserDir/Documents/美少女万華鏡３" "美少女万華鏡３" $OneDrive
    CreateSymbolicLink "$env:APPDATA/Nitroplus" "Nitroplus" $OneDrive
}
