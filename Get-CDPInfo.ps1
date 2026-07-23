param(
    [Parameter(Mandatory=$false)]
    [string]$FileName
)

if (!($FileName -eq "")){
    if (!(Test-Path -Path $FileName -PathType Leaf)) {
        Write-Host "Specified file does not exist. Press any key to exit." -ForegroundColor Red
        Read-Host
        exit
    }
}



$tshark = "C:\Program Files\Wireshark\tshark.exe"

if (!(Test-Path $tshark)){

Write-Host -ForegroundColor Red "Wireshark not installed. Please install it. Press any key to exit."
Read-Host
exit

}

if ($FileName -eq ""){


    $interfaces = Get-NetAdapter | Select-Object -ExpandProperty Name

        $selected = 0
        $key = $null

            do {
            Clear-Host
            if ($title){
            Write-Host "=== Select an Interface ===`n"
            }

            for ($i = 0; $i -lt $interfaces.Count; $i++) {
                if ($i -eq $selected) {
                    Write-Host "> $($interfaces[$i])" -ForegroundColor Green
                } else {
                    Write-Host "  $($interfaces[$i])"
                }
            }

            $key = [Console]::ReadKey($true).Key

            switch ($key) {
                "UpArrow"   { if ($selected -gt 0) { $selected-- } else { $selected = $interfaces.Count - 1 } }
                "DownArrow" { if ($selected -lt ($interfaces.Count - 1)) { $selected++ } else { $selected = 0 } }
            }

        } while ($key -ne "Enter")


    Write-Host -ForegroundColor Blue "Capturing (this might take a bit)..."

    & $tshark -i $interfaces[$selected] -f "ether dst 01:00:0c:cc:cc:cc" -c 1 -w $env:TEMP\cdpcapture.pcap > $null 2> $null

    $PcapFile = "$env:TEMP\cdpcapture.pcap"
	
	$ClientMAC =  $(Get-NetAdapter -InterfaceAlias $interfaces[$selected] | Select-Object -ExpandProperty MacAddress).Replace("-",":")

    $SwitchNAME = $(& $tshark -r $pcapFile -V -Y cdp -T fields -e cdp.deviceid)

    $PortID = $(& $tshark -r $pcapFile -V -Y cdp -T fields -e cdp.portid)

    $NativeVLAN = $(& $tshark -r $pcapFile -V -Y cdp -T fields -e cdp.native_vlan)

}
else{

    $PcapFile = $FileName
	
	$ClientMAC =  "Unable to get current MAC since this is reading from a previous packet capture."

    $SwitchNAME = $(& $tshark -r $pcapFile -V -Y cdp -T fields -e cdp.deviceid)

    $PortID = $(& $tshark -r $pcapFile -V -Y cdp -T fields -e cdp.portid)

    $NativeVLAN = $(& $tshark -r $pcapFile -V -Y cdp -T fields -e cdp.native_vlan)

}




Write-Host "Client MAC Address: $ClientMAC"

Write-Host "Switch Name: $SwitchNAME" 

Write-Host "Port ID: $PortID"

Write-Host "Native VLAN: $NativeVLAN" 

Write-Host ""

Write-Host "Press any key to exit."

Read-Host

Remove-Item $env:TEMP\cdpcapture.pcap -Force > $null 2> $null

exit