@echo off
for /f "tokens=3" %%A in ('manage-bde -status C: ^| find "Lock Status"') do (
    if "%%A"=="Locked" (
        echo Selected Drive is bitlocked. 

		choice /c YN /n /m "Do you have the key? (Y/N) "

		if errorlevel 2 (
			echo exiting...
			exit
		) else (
			echo Not locked. Continuing...
		)
    ) else (
        echo Selected Drive is not bitlocked.
    )
)

echo End of script!!!