$action = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument '-NoProfile -ExecutionPolicy Bypass install-windowsupdate -acceptall -microsoftupdate -autoreboot'

$trigger = New-ScheduledTaskTrigger `
    -Once `
    -At "5:00PM"

$principal = New-ScheduledTaskPrincipal `
    -UserId "SYSTEM" `
    -LogonType ServiceAccount `
    -RunLevel Highest

Register-ScheduledTask `
    -TaskName "Install Windows Updates" `
    -Action $action `
    -Trigger $trigger `
    -Principal $principal `
    -Description "Installs Updates and Reboots"