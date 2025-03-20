
$ProgressPreference = 'silentlycontinue'

Invoke-webrequest -uri https://go.microsoft.com/fwlink/?linkid=2171764 -outfile $env:TEMP\Updater.exe -UseBasicParsing 

& $env:TEMP\Updater.exe /skipeula /auto clean /DynamicUpdate Enable 