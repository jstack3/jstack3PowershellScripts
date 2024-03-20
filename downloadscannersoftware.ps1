# Blank #


$ProgressPreference = 'SilentlyContinue'

Invoke-WebRequest -Uri "https://pdisp01.c-wss.com/gdl/WWUFORedirectTarget.do?id=MDEwMDAwNjAzMTAx&cmp=ABR&lang=EN" -OutFile "$env:TEMP\ScannerSetup.exe"

Start-Process "$env:TEMP\ScannerSetup.exe"