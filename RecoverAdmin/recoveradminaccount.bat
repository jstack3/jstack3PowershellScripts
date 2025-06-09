
@echo off

setlocal enabledelayedexpansion

REM This script modifies a couple of system registries that will launch the command prompt on next startup. This is intended for Windows local account/device recovery. 
REM Place this script on an accessible directory (removable media would be the easiest).
REM Boot into a windows recovery environment command prompt. This can be done by holding down SHIFT while selecting restart on lock screen. You can also pull up a recovery command prompt by booting into a windows installer and using SHIFT + F10. 
REM Use diskpart list vol / list disk to determine drive letters.
REM Script syntax: "<MediaWithScript>:\Path\To\recoveradminaccount.bat <Drive Letter>:" 
REM Once you boot back into Windows an administrative command prompt will appear that will allow you to make user changes if necessary.
REM ***You will only get one chance to run commands on that command prompt before needing to run this script again. Be aware that a mouse click hides the command prompt***
REM Example to create an admin user: "net user <username> /ADD *; net localgroup Administrators /ADD <username>".
REM Example to reset password on local account: "net user <username> *".
REM Registry HKLM\SYSTEM\Setup SetupType will revert back to normal, however HKLM\SYSTEM\Setup CmdLine will still be set to cmd.exe. Command line startup does not persist but if you want to be safe you can set CmdLine back to a blank value.



if "%1"=="" (
    echo No drive letter selected... To check drive letters run "diskpart", then "list vol".
    echo MAKE SURE DRIVE LETTER INCLUDES ":"
    goto end

) else (
    echo You selected Drive: %1
    for /f "tokens=3" %%A in ('manage-bde -status %1 ^| find "Lock Status"') do (
    if "%%A"=="Locked" (
        echo Selected Drive is bitlocked. 

        set /p key_check="Do you have the key (Y/n)? "

        if /I NOT "!key_check!"=="Y" (
            echo Going to end!
            goto end
        )

        set /p recovery_key="Type in the key (with dashes): "

        manage-bde -unlock %1 -RecoveryPassword !recovery_key! > %TEMP%\bde_output.txt

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

	dir %1\ > null
    if %errorlevel% equ 1 (
       echo "Selected drive letter %1 is not valid!!. Ensure drive is plugged in and accessible. You can also try manually unlocking the bitlocker protection if you have the key (manage-bde -unlock <DriveLetter>: -RecoveryPassword <Key>)."
	   goto end

     )
    reg load HKLM\TEMPSYSHIVE "%1\Windows\System32\config\SYSTEM"

    if %errorlevel% equ 0 (
        echo Registry hive loaded successfully.
        echo Updating registry entries!
        reg add "HKLM\TEMPSYSHIVE\Setup" /v CmdLine /t REG_SZ /d "cmd.exe" /f
        reg add "HKLM\TEMPSYSHIVE\Setup" /v SetupType /t REG_DWORD /d 0x00000002 /f
        echo Registry entries updated!
        reg unload HKLM\TEMPSYSHIVE
        echo Registry hive unloaded successfully.
        echo Changes made to system to launch cmd on startup! Exit command prompt and restart computer!
        echo ON STARTUP: Use net user commands to change admin password or create local admin account. When you are finished modifying user accounts type "exit" to get back to lock screen.
    ) else (
        echo Failed to load registy from provided drive letter! Please make sure you include the colon with no backslash after the drive letter!
        goto end
    )

)

:end
echo End of script!!!

