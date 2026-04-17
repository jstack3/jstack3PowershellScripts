Get-Process | Where-Object ProcessName -eq "ms-teams" | Stop-Process
Remove-Item $env:LOCALAPPDATA\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams -Recurse -Force
Start-Process ms-teams
Read-Host