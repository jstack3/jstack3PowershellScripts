

# Blank Space #


param(
    [Parameter(Mandatory=$false)]
    [string]$FileName,
    [string]$Interface,
    [switch]$lldpONLY,
    [switch]$cdpONLY
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

if ($Interface -eq "" -and $FileName -eq "") {

    $interfaces = Get-NetAdapter | Select-Object -ExpandProperty Name

    $selected = 0
    $key = $null

    do {
        Clear-Host
        Write-Host "=== Select an Interface ===`n"

        for ($i = 0; $i -lt $interfaces.Count; $i++) {
            if ($i -eq $selected) {
                Write-Host "> $($interfaces[$i])" -ForegroundColor Green
            }
            else {
                Write-Host "  $($interfaces[$i])"
            }
        }

        $key = [Console]::ReadKey($true).Key

        switch ($key) {
            "UpArrow" {
                if ($selected -gt 0) {
                    $selected--
                }
                else {
                    $selected = $interfaces.Count - 1
                }
            }

            "DownArrow" {
                if ($selected -lt ($interfaces.Count - 1)) {
                    $selected++
                }
                else {
                    $selected = 0
                }
            }
        }

    } while ($key -ne "Enter")

    $interface = $interfaces[$selected]
}

if ($FileName -eq "") {

    $ClientMAC = (Get-NetAdapter -InterfaceAlias $interface | Select-Object -ExpandProperty MacAddress).Replace("-",":")

}
else {

    $ClientMAC = "Unable to get current MAC since this is reading from a previous packet capture."

}


if ($lldpONLY -or (!$lldpONLY -and !$cdpONLY)) {

    Write-Host -ForegroundColor Blue "Capturing LLDP Packets. This will stop after 60 seconds if no matching packets are found. Please wait... "

    if ($FileName -eq "") {
    
        & $tshark -i $interface -f "ether proto 0x88cc" -c 1 -a "duration:60" -w $env:TEMP\LLDPcapture.pcap > $null 2> $null

        $LLDPpcapFile = "$env:TEMP\LLDPcapture.pcap"

    }
    else {

        $LLDPpcapFile = $FileName

    }

    $LLDPText = "=== LLDP Information Is Listed Below ==="

    $LLDPSwitchMAC = $(& $tshark -r $LLDPpcapFile -V -Y lldp -T fields -e lldp.chassis.id.mac).ToUpper()

    $LLDPSwitchNAME = $(& $tshark -r $LLDPpcapFile -V -Y lldp -T fields -e lldp.tlv.system.name)

    $LLDPPortID = $(& $tshark -r $LLDPpcapFile -V -Y lldp -T fields -e lldp.port.id)

    $LLDPNativeVLAN = $(& $tshark -r $LLDPpcapFile -V -Y lldp -T fields -e lldp.ieee.802_1.vlan.id)

    $LLDPNativeVLAN_Name = $(& $tshark -r $LLDPpcapFile -V -Y lldp -T fields -e lldp.ieee.802_1.vlan.name)

    $LLDPAvailableVLANS = $(& $tshark -r $LLDPpcapFile -V -Y lldp -T fields -e lldp.ieee.802_1.port_vlan.id)    
}


if ($cdpONLY -or (!$lldpONLY -and !$cdpONLY)) {

    Write-Host -ForegroundColor Blue "Capturing CDP Packets. This will stop after 60 seconds if no matching packets are found. Please wait... "

    if ($FileName -eq "") {
    
        & $tshark -i $interface -f "ether dst 01:00:0c:cc:cc:cc" -c 1 -a "duration:60" -w $env:TEMP\CDPcapture.pcap > $null 2> $null

        $CDPpcapFile = "$env:TEMP\CDPcapture.pcap"

    }
    else {

        $CDPpcapFile = $FileName

    }

    $CDPText = "=== CDP Information Is Listed Below ==="

    $CDPSwitchNAME = $(& $tshark -r $CDPpcapFile -V -Y cdp -T fields -e cdp.deviceid)

    $CDPPortID = $(& $tshark -r $CDPpcapFile -V -Y cdp -T fields -e cdp.portid)

    $CDPNativeVLAN = $(& $tshark -r $CDPpcapFile -V -Y cdp -T fields -e cdp.native_vlan)

}

Write-Host "`nClient MAC: $ClientMAC"

if ($lldpONLY -or (!$lldpONLY -and !$cdpONLY)) {

    Write-Host "`n$LLDPText`nSwitch MAC: $LLDPSwitchMAC`nSwitch Name: $LLDPSwitchNAME`nPort ID: $LLDPPortID`nNative VLAN: $LLDPNativeVLAN`nAvailable VLANs: $LLDPAvailableVLANS"

}

if ($cdpONLY -or (!$lldpONLY -and !$cdpONLY)) {

    Write-Host "`n$CDPText`nSwitch Name: $CDPSwitchNAME`nPort ID: $CDPPortID`nNative VLAN: $CDPNativeVLAN"

}



Write-Host "`nPress any key to exit."

Read-Host

