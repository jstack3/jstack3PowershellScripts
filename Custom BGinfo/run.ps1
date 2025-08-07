if (Test-Path $env:TEMP\bginfoNETWORK.txt){

Remove-Item $env:TEMP\bginfoNETWORK.txt

}



$interfaces = Get-NetAdapter -Physical | Where-Object InterfaceType -eq 6

foreach ($interface in $interfaces) {

$ipaddress = Get-NetIPAddress -InterfaceAlias $interface.InterfaceAlias | Select-Object -ExpandProperty IPv4Address

$macaddress = $interface.MacAddress

$interfaceDescription = $interface.InterfaceDescription

$interfaceDescription + " -- " + $ipaddress + " -- " + $macaddress | Add-Content -Path "$env:TEMP\bginfoNETWORK.txt"

}

Expand-Archive BGInfo.zip -DestinationPath .\BGInfo\

Start-Process -Wait .\BGInfo\Bginfo.exe -ArgumentList "MACinfo.bgi", "/silent", "/timer:0", "/accepteula"