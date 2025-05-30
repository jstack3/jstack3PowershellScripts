param (
    [Parameter(Mandatory=$true)]
    [string]$folderpath
)

if (!(Test-Path $folderpath)){

Write-Host -ForegroundColor Red "Invalid folder! Try again!"
Read-Host
exit

}


$data = @()

$newfile = $folderPath + "\all.csv"

if (Test-Path $newfile){

Remove-Item -Force $newfile

}


$files = Get-ChildItem -Path $folderPath -File

foreach ($file in $files) {

$filepath = $folderPath + "\" + $file


$data += Import-Csv -Path $filepath -ErrorAction Stop



}

$data | Export-Csv -Path $newfile -Force -NoTypeInformation
