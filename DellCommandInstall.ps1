
 ### Blank Space ####

 $PowershellPrompt = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())

if (!($PowershellPrompt.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Host -ForegroundColor Red "Please run this script as Admin! Press any key to quit!"
    Read-Host
    exit
}


Write-Host 'Downloading Dell Command Update Installer...'

$headers = @{
  'User-Agent' = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.82 Safari/537.36'
}

Invoke-WebRequest -Uri "https://dl.dell.com/FOLDER10791716M/1/Dell-Command-Update-Windows-Universal-Application_JCVW3_WIN_5.1.0_A00.EXE" -OutFile "C:\Users\Public\Dell-Command-Update-Windows-Universal-Application_JCVW3_WIN_5.1.0_A00.EXE" -Headers $headers
Write-Host 'Extracting Dell Command Update Installer...'
Start-Process cmd.exe -Verb runAs -ArgumentList "/c C:\Users\Public\Dell-Command-Update-Windows-Universal-Application_JCVW3_WIN_5.1.0_A00.EXE /s /e=C:\Users\Public\DellCommandInstall" -Wait
Write-Host 'Installing Dell Command Update...'
Start-Process cmd.exe -Verb runAs -ArgumentList "/c C:\Users\Public\DellCommandInstall\DellCommandUpdateApp_Setup.exe /S /v/qn" -Wait


Write-Host 'Sleeping for 30 seconds while Dell Command Update Installs...'
Start-Sleep -Seconds 30

Write-Host 'Removing Installer...'
Remove-Item C:\Users\Public\Dell-Command-Update-Windows-Universal-Application_JCVW3_WIN_5.1.0_A00.EXE
Remove-Item C:\Users\Public\DellCommandInstall -Recurse

Write-Host "Press any key to restart the computer."
Read-Host

Restart-Computer -Force
