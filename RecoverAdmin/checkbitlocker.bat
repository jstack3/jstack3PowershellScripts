@echo off
for /f "tokens=3" %%A in ('manage-bde -status C: ^| find "Lock Status"') do (
    if "%%A"=="Locked" (
        echo Selected Drive is bitlocked. 

		set /p key_check="Do you have the key (Y/n)? "
		
		if NOT "%key_check%"=="Y" (
		echo Going to end!
		goto end
		)
		
		set /p recovery_key="Type in the key (with dashes): "
		
		manage-bde -unlock C: -RecoveryPassword %recovery_key%
		
		if ERRORLEVEL 1 (
			echo Error has occured with unlock!!!
			goto end
		)
			
		
    ) else (
        echo Selected Drive is not bitlocked.
    )
)

:end
echo End of script!!!