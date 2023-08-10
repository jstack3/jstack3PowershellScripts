﻿Echo 'Downloading Dell Command Update Installer...' 
$headers = @{
  'User-Agent' = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.82 Safari/537.36'
}
Invoke-WebRequest -Uri "https://dl.dell.com/FOLDER10408436M/1/Dell-Command-Update-Windows-Universal-Application_1WR6C_WIN_5.0.0_A00.EXE" -OutFile "C:\Users\Public\Dell-Command-Update-Windows-Universal-Application_1WR6C_WIN_5.0.0_A00.EXE" -Headers $headers
Echo 'Extracting Dell Command Update Installer...'
Start-Process cmd.exe -Verb runAs -ArgumentList "/c C:\Users\Public\Dell-Command-Update-Windows-Universal-Application_1WR6C_WIN_5.0.0_A00.EXE /s /e=C:\Users\Public\DellCommandInstall" -Wait
Echo 'Installing Dell Command Update...'
Start-Process cmd.exe -Verb runAs -ArgumentList "/c C:\Users\Public\DellCommandInstall\DellCommandUpdateApp_Setup.exe /S /v/qn" -Wait


Echo 'Sleeping for 30 seconds while Dell Command Update Installs...'
Start-Sleep -Seconds 30

Echo 'Removing Installer...'
Remove-Item C:\Users\Public\Dell-Command-Update-Windows-Universal-Application_1WR6C_WIN_5.0.0_A00.EXE
Remove-Item C:\Users\Public\DellCommandInstall -Recurse

Write-Host "Press any key to restart the computer."
$host.UI.RawUI.FlushInputBuffer()

while ($true) {
    $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

    if ($key.VirtualKeyCode -ne 0) {
        Restart-Computer -Force
    }
}