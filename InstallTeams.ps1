$ProgressPreference = 'SilentlyContinue'


Write-Host "Downloading Teams.."

Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?linkid=2196106&clcid=0x409&culture=en-us&country=us" -OutFile "$env:TEMP\teams.msix"

Write-Host "Installing Teams..."

Add-AppPackage -Path "$env:TEMP\teams.msix"

Write-Host "Done"


Read-Host "Press enter to delete install files"


if (Test-Path "$env:TEMP\teams.msix"){

Remove-Item "$env:TEMP\teams.msix" -Force -ErrorAction SilentlyContinue

}