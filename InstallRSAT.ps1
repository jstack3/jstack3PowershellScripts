

$PowershellPrompt = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())

if (!($PowershellPrompt.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Host -ForegroundColor Red "Please run this script as Admin! Press any key to quit!"
    Read-Host
    exit
}


while ($true){
    $selection = Read-Host -Prompt "How would you like to install the Active Directory Powershell Module?`n[1]Install RSAT (Slower, may fail on some computers)`n[2]Import Active Directory Powershell Module (Faster, some functionalities may be limited)`n[C]Cancel`n"
    if ($selection -in 1, 2, "C"){
        break
    }
    else{
        Write-Host -ForegroundColor Red "Invalid selection. Please select 1, 2, or C. Press any key to continue"
        Read-Host
        clear
    }
}

if ($selection -eq 1){
    try{
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

        Get-Command Get-ADComputer -ErrorAction Stop > $null
    }
    catch {
        Write-Host -ForegroundColor Red "RSAT install failed. Please try again or use a different method. Press any key to exit..."
        Read-Host
        exit
    }
}
elseif ($selection -eq 2){
    try{
        Write-Host "Downloading Active Directory Module..."
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/jstack3/jstack3PowershellScripts/main/ADPSModule/ActiveDirectory.zip" -OutFile "$env:TEMP\ActiveDirectory.zip"

        Write-Host "Extracting/Importing Active Directory Module..."
        Expand-Archive -Path "$env:TEMP\ActiveDirectory.zip" -DestinationPath "$env:SystemRoot\System32\WindowsPowerShell\v1.0\Modules\ActiveDirectory"

        Write-Host "Removing Active Directory Module Zip..."
        Remove-Item -Path "$env:TEMP\ActiveDirectory.zip"

        Get-Command Get-ADComputer -ErrorAction Stop > $null
    }
    catch {
        Write-Host -ForegroundColor Red "Failed to download/install Active Directory Module. Please try again or use a different method. Press any key to exit..."
        Read-Host
        if (Test-Path "$env:TEMP\ActiveDirectory.zip" -PathType Leaf ){
            Remove-Item -Path "$env:TEMP\ActiveDirectory.zip"
        }
    }
}
elseif ($selection -eq "C"){
    Write-Host "Cancelling script..."
    exit
}

Write-Host "Script Complete... Press any key to exit."
Read-Host
