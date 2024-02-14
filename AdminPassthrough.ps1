param (
    [Parameter(Mandatory=$true)]
    [string]$commandtorun
)

Start-Process powershell -Verb RunAs -ArgumentList "-Command", "$commandtorun" -Wait
