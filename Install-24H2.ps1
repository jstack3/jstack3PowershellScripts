
$ProgressPreference = 'silentlycontinue'

Invoke-webrequest -uri https://go.microsoft.com/fwlink/?linkid=2171764 -outfile $env:TEMP\Updater.exe -UseBasicParsing 

#& $env:TEMP\Updater.exe /skipeula /auto clean /DynamicUpdate Enable 

Start-Process "$env:TEMP\Updater.exe" -ArgumentList "/skipeula", "/auto clean", "/DynamicUpdate Enable ", "/quietinstall" -wait
