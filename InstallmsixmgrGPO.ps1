$ProgressPreference = 'SilentlyContinue'

Invoke-WebRequest -Uri "https://download.microsoft.com/download/d/3/5/d35c060c-d402-4a9c-ad40-234ad5e4d2e8/DesktopAppInstallerPolicies.zip" -OutFile "$env:TEMP\msixmgrGPO.zip"

Expand-Archive -LiteralPath '$env:TEMP\msixmgrGPO.zip' -DestinationPath '$env:TEMP\msixmgrGPO' -Force

Copy-Item -LiteralPath '$env:TEMP\msixmgrGPO\admx\en-US\DesktopAppInstaller.adml' -Destination 'C:\Windows\PolicyDefinitions\en-US\.'
