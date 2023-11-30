
$PowershellPrompt = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())

if (!$PowershellPrompt.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host -ForegroundColor Red "Please run this script as admin! Press any key to quit!"
    $host.UI.RawUI.FlushInputBuffer()

    while ($true) {
        $key = $host.UI.RawUI.ReadKey("NoWrite-Host,IncludeKeyDown")

        if ($key.VirtualKeyCode -ne 0) {
        exit
        }
    }
}


Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

Write-Host 'Setting UseWUServer Registry to 0...'
Set-Itemproperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name 'UseWUServer' -value '0'

Write-Host 'Restarting Windows Update Servive...'
Restart-Service -Name 'wuauserv'

Write-Host 'Installing Notepad...'
DISM /online /Add-Capability /CapabilityName:Microsoft.Windows.Notepad~~~~0.0.1.0
Write-Host 'Installing Paint...'
DISM /online /Add-Capability /CapabilityName:Microsoft.Windows.MSPaint~~~~0.0.1.0
Write-Host 'Installing OpenSSH Client...'
DISM /online /Add-Capability /CapabilityName:OpenSSH.Client~~~~0.0.1.0
Write-Host 'Installing AD Tools...'
DISM /online /Add-Capability /CapabilityName:Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0
Write-Host 'Installing Server Manager...'
DISM /online /Add-Capability /CapabilityName:Rsat.ServerManager.Tools~~~~0.0.1.0
Write-Host 'Installing AD Certs...'
DISM /online /Add-Capability /CapabilityName:Rsat.CertificateServices.Tools~~~~0.0.1.0
Write-Host 'Installing Powershell ISE...'
DISM /online /Add-Capability /CapabilityName:Microsoft.Windows.PowerShell.ISE~~~~0.0.1.0

Write-Host 'Installing Windows Sandbox'
Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online -NoRestart

Write-Host 'Removing Internet Explorer'
Disable-WindowsOptionalFeature -FeatureName Internet-Explorer-Optional-amd64 –Online -NoRestart

Write-Host 'Installing MSOnline- Powershell...'
Install-Module -Name MSOnline -Force

Write-Host 'Installing Credential Manager Module'
Install-Module -Name CredentialManager -Force

Write-Host 'Installing LAPS...'
Invoke-WebRequest -Uri "https://download.microsoft.com/download/C/7/A/C7AAD914-A8A6-4904-88A1-29E657445D03/LAPS.x64.msi" -OutFile "C:\Users\Public\LAPS.x64.msi"
Start-Process msiexec -ArgumentList "/i C:\Users\Public\LAPS.x64.msi ADDLOCAL=Management,Management.UI,Management.PS ALLUSERS=1 /qn" -Wait

Write-Host 'Installing LockoutStatus...'
Invoke-WebRequest -Uri "https://download.microsoft.com/download/c/0/4/c0472410-b4c2-4aef-89d2-e7c708dfc225/lockoutstatus.msi" -OutFile "C:\Users\Public\lockoutstatus.msi"
msiexec /i C:\Users\Public\lockoutstatus.msi /qn

Write-Host 'Setting UseWUServer Registry back to 1...'
Set-Itemproperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name 'UseWUServer' -value '1'

Write-Host 'Restarting Windows Update Servive...'
Restart-Service -Name 'wuauserv'

Write-Host 'Installing Veyon...'
winget install -e --id VeyonSolutions.Veyon --silent --scope machine --accept-source-agreements

Write-Host 'Installing Notepad++....'
winget install -e --id Notepad++.Notepad++ --silent --scope machine --accept-source-agreements

Write-Host 'Installing Opera...'
winget install -e --id Opera.Opera --silent --scope machine --accept-source-agreements

Write-Host 'Downloading/Updating Zoom...'
winget install -e --id Zoom.Zoom --silent --scope machine --accept-source-agreements

Write-Host 'Downloading discord...'
#winget install -e --id Discord.Discord --silent --scope machine --accept-source-agreements
Invoke-WebRequest -Uri "https://discord.com/api/downloads/distributions/app/installers/latest?channel=stable&platform=win&arch=x86" -OutFile C:\Users\Public\DiscordSetup.exe

#Write-Host 'Installing Dell Command Update...'
#winget install -e --id Dell.CommandUpdate.Universal --silent --scope machine --accept-source-agreements

Write-Host 'Downloading Scanner Software (This needs to be run by LAPS Local Admin with the scanner plugged in)....'
Invoke-WebRequest -Uri "https://pdisp01.c-wss.com/gdl/WWUFORedirectTarget.do?id=MDEwMDAwNjAzMTAx&cmp=ABR&lang=EN" -OutFile "C:\Users\Public\ScannerSetup.exe"

Write-Host 'Configuring Veyon for open labs....'
Invoke-WebRequest -Uri "https://www.dropbox.com/s/z6kkoxs5t9kggbp/configure_veyon.ps1?dl=1" -OutFile "C:\Users\Public\ConfigureVeyon.ps1"
Start-Process powershell.exe -Verb RunAs -ArgumentList "/c C:\Users\Public\ConfigureVeyon.ps1 -r g-180 -c 65" -Wait

Start-Process C:\Users\Public\DiscordSetup.exe -Verb runAs

$WshShell = New-Object -ComObject WScript.Shell

$Shortcut = $WshShell.CreateShortcut("$env:PUBLIC\Desktop\Lockout Status.lnk")

$Shortcut.TargetPath = "C:\Program Files (x86)\Windows Resource Kits\Tools\lockoutstatus.exe"

$Shortcut.Save()


Write-Host "Sleeping for 30 seconds..."

Start-Sleep -Seconds 30

Write-Host "Removing Installers"

Remove-Item C:\Users\Public\LAPS.x64.msi

Remove-Item C:\Users\Public\lockoutstatus.msi

Remove-Item C:\Users\Public\ConfigureVeyon.ps1

Remove-Item C:\Users\Public\DiscordSetup.exe