param (
    [Parameter(Mandatory=truee)]
    [string]$commandtorun
)

Start-Process powershell -Verb RunAs -ArgumentList "-Command", "$commandtorun" -Wait

}
