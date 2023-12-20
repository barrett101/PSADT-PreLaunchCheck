# PSADT-PreLaunchCheck

## DESCRIPTION
This is a PSADT prelaunch script.  If no user is logged in or if OOBE/ESP/Autopilot is running it will run in NonInteractive Mode, otherwise it will run
in ServiceUI.exe mode to elevate the GUI.  

Log file can be found below.  The logs will be overridden each time an Win32 app is installed.

C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Win32App_PSADT_PreLaunch.log


## EXAMPLE - INSTALL
Below will run the script in Install mode

Win32App_PSADT_PreLaunch.ps1 -DeploymentType Install

Use below for Intune Install Command field

powershell.exe -executionpolicy bypass -file "Win32App_PSADT_PreLaunch.ps1" -DeploymentType Install

## EXAMPLE - UNINSTALL
Below will run the script in Install mode

Win32App_PSADT_PreLaunch.ps1 -DeploymentType Uninstall

Use below for Intune Uninstall Command field

powershell.exe -executionpolicy bypass -file "Win32App_PSADT_PreLaunch.ps1" -DeploymentType Uninstall
