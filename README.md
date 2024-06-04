# PSADT-PreLaunchCheck

## DESCRIPTION
### Win32App_PSADT_PreLaunch.ps1
This is a PSADT prelaunch script designed for Intune.  If no user is logged in or if OOBE/Autopilot (not user ESP) is running it will run in NonInteractive Mode, otherwise it will run
in ServiceUI.exe mode to elevate the GUI Prompt to the user.  The ServiceUI.exe here is the x64 version of the file.  
### Win32App_PSADT_PreLaunch_ProcessCheck.ps1
This is a PSADT prelaunch script designed for Intune.  This script was made as there is not a good way to detect the user ESP when enrolling a device though Autopilot in Hybrid Domain Join scenario.  You can detect the device side with the defaultuser0 and waahost process, but the user ESP side is performed while the domain user is logged in.  Adding the process check allow the use ESP side to install the application without any GUI prompt to the user.  Make sure the processes you exclude match the processes specified in the Deploy-Application.ps1 file under the Show-InstallationWelcome, you want both sides to match. If you don't want to perform a check just enter a process that will never exist (ex. SkipProcessCheckForPSADT) for the process argument, it will never find it and it will in all cases run in NonInteractive mode.  The only time it will display the GUI Prompt to the user is if a process if running, otherwise it will always run as NonInteractive.

### Additional Details
Log file can be found below.  The logs will be overridden each time an Win32 app is installed.

C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Win32App_PSADT_PreLaunch.log


## EXAMPLE - Win32App_PSADT_PreLaunch.ps1 - INSTALL
Below will run the script in Install mode

Win32App_PSADT_PreLaunch.ps1 -DeploymentType "Install"

Use below for Intune Install Command field

powershell.exe -executionpolicy bypass -file "Win32App_PSADT_PreLaunch.ps1" -DeploymentType "Install"

## EXAMPLE - Win32App_PSADT_PreLaunch.ps1 - UNINSTALL
Below will run the script in Install mode

Win32App_PSADT_PreLaunch.ps1 -DeploymentType "Uninstall"

Use below for Intune Uninstall Command field

powershell.exe -executionpolicy bypass -file "Win32App_PSADT_PreLaunch.ps1" -DeploymentType "Uninstall"


## EXAMPLE - Win32App_PSADT_PreLaunch_ProcessCheck.ps1 - INSTALL
Below will run the script in Install mode, and check for process notepad and winword.

Win32App_PSADT_PreLaunch_ProcessCheck.ps1 -DeploymentType "Install" -Process "notepad,winword"

Use below for Intune Install Command field

powershell.exe -executionpolicy bypass -file "Win32App_PSADT_PreLaunch_ProcessCheck.ps1" -DeploymentType "Install" -Process "notepad,winword"

## EXAMPLE - Win32App_PSADT_PreLaunch_ProcessCheck.ps1 - UNINSTALL
Below will run the script in Install mode, and check for process notepad and winword.

Win32App_PSADT_PreLaunch_ProcessCheck.ps1 -DeploymentType Uninstall -Process "notepad,winword"

Use below for Intune Uninstall Command field

powershell.exe -executionpolicy bypass -file "Win32App_PSADT_PreLaunch_ProcessCheck.ps1" -DeploymentType Uninstall -Process "notepad,winword"
