


$ProgressPreference = 'SilentlyContinue'

Write-Host "Downloading .NET update..."

Invoke-WebRequest -Uri 'https://catalog.s.download.windowsupdate.com/c/msdownload/update/software/secu/2024/03/windows11.0-kb5036620-x64-ndp481_8d9e9e98b1edcb7e74e3e7365f6ec55dcb8bf3c4.msu' -OutFile "$env:TEMP\dotNETUpdate.msu"

$ProgressPreference = 'Continue'

$UpdateFilePath = "$env:TEMP\dotNETUpdate.msu"

Write-Host "Installing .NET update..."

Start-Process -wait wusa -ArgumentList "/update $UpdateFilePath","/quiet","/norestart"

#irm https://raw.githubusercontent.com/jstack3/jstack3PowershellScripts/main/InstallMC.ps1 | iex

irm https://raw.githubusercontent.com/jstack3/jstack3PowershellScripts/main/DellCommandInstall.ps1 | iex