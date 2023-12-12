
Write-Host 'Setting UseWUServer Registry to 0...'
Set-Itemproperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name 'UseWUServer' -value '0'

Write-Host 'Restarting Windows Update Servive...'
Restart-Service -Name 'wuauserv'

Write-Host 'Installing RSAT...'
DISM /online /Add-Capability /CapabilityName:Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0

Write-Host 'Setting UseWUServer Registry back to 1...'
Set-Itemproperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name 'UseWUServer' -value '1'

Write-Host 'Restarting Windows Update Servive...'
Restart-Service -Name 'wuauserv'

Write-Host "Script Complete... Press any key to exit."
Read-Host