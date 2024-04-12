
 ### Blank Space ####

 $ProgressPreference = 'SilentlyContinue'

 $PowershellPrompt = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())

if (!($PowershellPrompt.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Host -ForegroundColor Red "Please run this script as Admin! Press any key to quit!"
    Read-Host
    exit
}

Write-Host "Downloading Minecraft Education Installer..."

Invoke-WebRequest -Uri "https://aka.ms/downloadmee-desktopApp" -OutFile "$env:USERPROFILE\Downloads\MinecraftEducationInstall.exe"

Write-Host "Installing Minecraft Education..."

Start-Process cmd.exe -Verb runAs -ArgumentList "/c %USERPROFILE%\Downloads\MinecraftEducationInstall.exe /exenoui" -Wait

Write-Host 'Sleeping for 30 seconds while Minecraft Installs...'
Start-Sleep -Seconds 30
