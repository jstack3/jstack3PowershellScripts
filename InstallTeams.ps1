$ProgressPreference = 'SilentlyContinue'

$teams = Get-AppPackage | Where-Object Name -EQ "MSTeams"

if ($null -eq $teams){

Write-Host "Downloading Teams.."

Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?linkid=2196106&clcid=0x409&culture=en-us&country=us" -OutFile "$env:TEMP\teams.msix"

Write-Host "Installing Teams..."

Add-AppPackage -Path "$env:TEMP\teams.msix"

Write-Host "Done"

}
else{
Write-Host -ForegroundColor Red "Teams Installed Already!!"
}
