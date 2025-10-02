$tshark = "C:\Program Files\Wireshark\tshark.exe"

if (!(Test-Path $tshark)){

Write-Host -ForegroundColor Red "Wireshark not installed. Please install it. Press any key to exit."
Read-Host
exit

}


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


$SwitchNAME = $(& $tshark -r $env:TEMP\lldpcapture.pcap -V -Y lldp -T fields -e lldp.tlv.system.name)

$PortID = $(& $tshark -r $env:TEMP\lldpcapture.pcap -V -Y lldp -T fields -e lldp.port.id)

$NativeVLAN = $(& $tshark -r $env:TEMP\lldpcapture.pcap -V -Y lldp -T fields -e lldp.ieee.802_1.vlan.id)

$NativeVLAN_Name = $(& $tshark -r $env:TEMP\lldpcapture.pcap -V -Y lldp -T fields -e lldp.ieee.802_1.vlan.name)

$AvailableVLANS = $(& $tshark -r $env:TEMP\lldpcapture.pcap -V -Y lldp -T fields -e lldp.ieee.802_1.port_vlan.id)


Write-Host "Switch Name: --$SwitchNAME-- Port ID: --$PortID-- Native VLAN: --$NativeVLAN-- Native VLAN Name: --$NativeVLAN_Name-- Available VLANS: --$AvailableVLANS--"

Write-Host "Press any key to exit."

Read-Host

exit