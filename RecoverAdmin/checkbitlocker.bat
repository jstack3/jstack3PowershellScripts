@echo off
setlocal enabledelayedexpansion
for /f "tokens=3" %%A in ('manage-bde -status C: ^| find "Lock Status"') do (
if "%%A"=="Locked" (
	echo Selected Drive is bitlocked. 

	set /p key_check="Do you have the key (Y/n)? "

	if /I NOT "!key_check!"=="Y" (
		echo Going to end!
		goto end
	)

	set /p recovery_key="Type in the key (with dashes): "

	manage-bde -unlock C: -RecoveryPassword !recovery_key! > %TEMP%\bde_output.txt

	find "ERROR" %TEMP%\bde_output.txt >nul
	if not errorlevel 1 (
		echo Error while unlocking drive. Going to end.
		goto end
	) else (
		echo No errors while unlocking drive. Continuing...
	)
) else (
	echo Selected Drive is not bitlocked.
)
)

:end
echo End of script!!!