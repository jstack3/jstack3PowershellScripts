
@echo off

REM This script modifies a couple of system registries that will launch the command prompt on next startup. This is intended for account recovery. 
REM Place this script in a directory named "AdminRecovery" under the root directory of an accessible drive.
REM Boot into a windows recovery environment command prompt. This can be done by holding down SHIFT while selecting restart on lock screen. You can also pull up a recovery command prompt by booting into a windows installation image and by selecting on Repair your computer.
REM Script syntax: <RemovableDriveLetter>:\Path\To\recoveradminaccount.bat <Drive Letter>: . (If you do not provide a drive letter the script will attempt to launch diskpark to list available volumes) BE SURE TO ONLY INCLUDE A COLON!
REM Once you boot back into Windows an administrative command prompt will appear that will allow you to make user changes if necessary. 
REM Registry HKLM\SYSTEM\Setup SetupType will revert back to normal, however HKLM\SYSTEM\Setup CmdLine will still be set to cmd.exe. Command line startup does not persist but if you want to be safe you can set CmdLine back to a blank value.



if "%1"=="" (
    echo No drive letter selected... Please select your main system drive from the list below:
    diskpart /s G:\AdminRecovery\listvol.txt
    if %errorlevel% equ 0 (
        echo Error running disk vol. To check drive letters run "diskpart", then "list vol".
    )
    echo MAKE SURE DRIVE LETTER INCLUDES ":"

) else (
    echo You selected Drive: %1
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
    )

)

