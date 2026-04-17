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

    & $tshark -i $interfaces[$selected] -f "ether proto 0x88cc" -c 1 -w $env:TEMP\lldpcapture.pcap > $null 2> $null

    $pcapFile = "$env:TEMP\lldpcapture.pcap"

    $SwitchNAME = $(& $tshark -r $pcapFile -V -Y lldp -T fields -e lldp.tlv.system.name)

    $PortID = $(& $tshark -r $pcapFile -V -Y lldp -T fields -e lldp.port.id)

    $NativeVLAN = $(& $tshark -r $pcapFile -V -Y lldp -T fields -e lldp.ieee.802_1.vlan.id)

    $NativeVLAN_Name = $(& $tshark -r $pcapFile -V -Y lldp -T fields -e lldp.ieee.802_1.vlan.name)

    $AvailableVLANS = $(& $tshark -r $pcapFile -V -Y lldp -T fields -e lldp.ieee.802_1.port_vlan.id)

}
else{

    $pcapFile = $FileName

    $SwitchNAME = $(& $tshark -r $pcapFile -V -Y lldp -T fields -e lldp.tlv.system.name) | Select-Object -First 1

    $PortID = $(& $tshark -r $pcapFile -V -Y lldp -T fields -e lldp.port.id) | Select-Object -First 1

    $NativeVLAN = $(& $tshark -r $pcapFile -V -Y lldp -T fields -e lldp.ieee.802_1.vlan.id) | Select-Object -First 1

    $NativeVLAN_Name = $(& $tshark -r $pcapFile -V -Y lldp -T fields -e lldp.ieee.802_1.vlan.name) | Select-Object -First 1

    $AvailableVLANS = $(& $tshark -r $pcapFile -V -Y lldp -T fields -e lldp.ieee.802_1.port_vlan.id) | Select-Object -First 1

}





Write-Host "Switch Name: $SwitchNAME" 

Write-Host "Port ID: $PortID"

Write-Host "Available VLANS: $AvailableVLANS"

Write-Host "Native VLAN: $NativeVLAN" 

Write-Host "Native VLAN Name: $NativeVLAN_Name"

Write-Host ""

Write-Host "Press any key to exit."

Read-Host

Remove-Item $env:TEMP\lldpcapture.pcap -Force > $null 2> $null

exit