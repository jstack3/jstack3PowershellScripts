Echo 'Setting UseWUServer Registry to 0...'
Set-Itemproperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name 'UseWUServer' -value '0'

Echo 'Restarting Windows Update Servive...'
Restart-Service -Name 'wuauserv'

Echo 'Installing Notepad...'
DISM /online /Add-Capability /CapabilityName:Microsoft.Windows.Notepad~~~~0.0.1.0
Echo 'Installing Paint...'
DISM /online /Add-Capability /CapabilityName:Microsoft.Windows.MSPaint~~~~0.0.1.0

Echo 'Removing Internet Explorer...'
Disable-WindowsOptionalFeature -FeatureName Internet-Explorer-Optional-amd64 –Online -NoRestart

Echo 'Setting UseWUServer Registry back to 1...'
Set-Itemproperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name 'UseWUServer' -value '1'

Echo 'Restarting Windows Update Servive...'
Restart-Service -Name 'wuauserv'

Echo 'Downloading Dell Command Update Installer...' 
$headers = @{
  'User-Agent' = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.82 Safari/537.36'
}
Invoke-WebRequest -Uri "https://dl.dell.com/FOLDER10012409M/3/Dell-Command-Update-Windows-Universal-Application_J6PNP_WIN_4.9.0_A02_02.EXE" -OutFile "C:\Users\Public\Dell-Command-Update-Windows-Universal-Application_J6PNP_WIN_4.9.0_A02_02.EXE" -Headers $headers
Echo 'Extracting Dell Command Update Installer...'
Start-Process cmd.exe -Verb runAs -ArgumentList "/c C:\Users\Public\Dell-Command-Update-Windows-Universal-Application_J6PNP_WIN_4.9.0_A02_02.EXE /s /e=C:\Users\Public\DellCommandInstall" -Wait
Echo 'Installing Dell Command Update...'
Start-Process cmd.exe -Verb runAs -ArgumentList "/c C:\Users\Public\DellCommandInstall\DellCommandUpdateApp_Setup.exe /S /v/qn" -Wait

Echo 'Downloading Veyon...'
Invoke-WebRequest -Uri "https://www.dropbox.com/s/6khgh44g7pkz1h3/Veyon.zip?dl=1" -OutFile "C:\Users\Public\Veyon.zip"
Expand-Archive -Path C:\Users\Public\Veyon.zip -DestinationPath C:\Users\Public\Veyon_Student\

##Veyon Install##
Echo 'Installing Veyon...'
Start-Process cmd.exe -Verb runAs -ArgumentList "/c C:\Users\Public\Veyon_Student\setup.cmd" -Wait

Echo 'Removing Veyon Installer...'

Remove-Item C:\Users\Public\Veyon_Student\ -Recurse
Remove-Item C:\Users\Public\Veyon.zip

Echo 'Sleeping for 30 seconds while Dell Command Update Installs...'
Start-Sleep -Seconds 30

Echo 'Removing Installer...'
Remove-Item C:\Users\Public\Dell-Command-Update-Windows-Universal-Application_J6PNP_WIN_4.9.0_A02_02.EXE
Remove-Item C:\Users\Public\DellCommandInstall -Recurse


Write-Host "Press any key to restart the computer."
$host.UI.RawUI.FlushInputBuffer()

while ($true) {
    $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

    if ($key.VirtualKeyCode -ne 0) {
        Restart-Computer -Force
    }
}
