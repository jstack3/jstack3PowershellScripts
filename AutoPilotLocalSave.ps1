

$PowershellPrompt = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())

if (!($PowershellPrompt.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Host -ForegroundColor Red "Run this script as admin!"
    Read-Host
    exit
}

Set-ExecutionPolicy -Scope currentuser -ExecutionPolicy ByPass -Force


Write-Host "Checking/Installing dependencies..."

$null = Install-PackageProvider -Name NuGet -Force

if(! (Get-Command Get-WindowsAutopilotInfo -ErrorAction SilentlyContinue)){

Install-Script -Name Get-WindowsAutopilotInfo -Force

}


$SerialNumber = (Get-WmiObject -class win32_bios).SerialNumber

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$env:Path += ";$env:SystemDrive\Program Files\WindowsPowerShell\Scripts"

Set-ExecutionPolicy -Scope currentuser -ExecutionPolicy ByPass -Force



Write-Host "Saving autopilot info..."

Try{

Get-WindowsAutopilotInfo -OutputFile "$env:USERPROFILE\Desktop\AutopilotHWID-$SerialNumber.csv"

}
Catch{

Write-Host -ForegroundColor Red "Error when running Get-WindowsAutopilotInfo!"

}


Write-Host "Done"