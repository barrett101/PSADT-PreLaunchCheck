﻿[CmdletBinding()]
param (
	[Parameter(Mandatory = $true)]
	[string]$Process,
	[Parameter(Mandatory = $true)]
	[string]$DeploymentType
)
#This will log the script and how it goes
Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Win32App_PSADT_PreLaunch.log"

#Below will get the active user logged in, if no user logged in, it will return variable as null.
$CheckUser = Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -ExpandProperty UserName
If ($CheckUser -eq $null)
{
	Write-Host "No User is Logged into Computer, running in Non-Interactive mode"
	If ($DeploymentType -eq "Install")
	{
		Write-Host "INSTALL DEPLOYMENT TYPE: No user logged in so run in Non-Interactive mode"
		Start-Process Deploy-Application.exe -Wait -ArgumentList '-DeployMode "NonInteractive"'
	}
	If ($DeploymentType -eq "Uninstall")
	{
		Write-Host "UNINSTALL DEPLOYMENT TYPE: No user logged in so run in Non-Interactive mode"
		Start-Process Deploy-Application.exe -Wait -ArgumentList '-DeployMode "NonInteractive" -DeploymentType "Uninstall"'
	}
}
else
{
	Write-Host "USERNAME in Variable is $CheckUser"
	If (($CheckUser -match "defaultuser0") -and (((Get-Process -Name 'wwahost' -ErrorAction 'SilentlyContinue').count) -gt 0))
	{
		Write-Host "DefaultUser0 is logged in and wwahost process running, this means OOBE/ESP/Autopilot is running - Will Run without ServiceUI.exe"
		If ($DeploymentType -eq "Install")
		{
			Write-Host "INSTALL DEPLOYMENT TYPE: DefaultUser0 is logged in so run in Non-Interactive mode"
			Start-Process Deploy-Application.exe -Wait -ArgumentList '-DeployMode "NonInteractive"'
		}
		If ($DeploymentType -eq "Uninstall")
		{
			Write-Host "UNINSTALL DEPLOYMENT TYPE: DefaultUser0 is logged in so run in Non-Interactive mode"
			Start-Process Deploy-Application.exe -Wait -ArgumentList '-DeployMode "NonInteractive" -DeploymentType "Uninstall"'
		}
	}
	else
	{
		#Check for processes, if present it will prompt the user, otherwise it runs silent.
		#splits the process list so it is in an array to send to the get-process
		$processList = $process -split ','
		Write-Host "List of Processes to check $Process"
		#If the process(es) are found it will interact with the user, otherwise it will run silent.
		If (Get-Process -Name $processList -ErrorAction SilentlyContinue)
		{
			Write-Host "$CheckUser is logged in (NOT DefaultUser0) to the computer and there are processes running, so will run with ServiceUI.exe to give user UI."
			If ($DeploymentType -eq "Install")
			{
				Write-Host "INSTALL DEPLOYMENT TYPE:  User is logged in, processes running.  Will run with ServiceUI.exe, in install mode."
				.\ServiceUI.exe -Process:explorer.exe Deploy-Application.exe
			}
			If ($DeploymentType -eq "Uninstall")
			{
				Write-Host "UNINSTALL DEPLOYMENT TYPE:  User is logged in, processes running.  Will run with ServiceUI.exe, in uninstall mode."
				.\ServiceUI.exe -Process:explorer.exe Deploy-Application.exe -DeploymentType Uninstall
			}
		}
		Else
		{
			Write-Host "User is logged in, but doesn't have any of the processes running. - Will Run without ServiceUI.exe in NonInteractive mode."
			If ($DeploymentType -eq "Install")
			{
				Write-Host "INSTALL DEPLOYMENT TYPE: User is logged, but no processes are running, so run in Non-Interactive mode"
				Start-Process Deploy-Application.exe -Wait -ArgumentList '-DeployMode "NonInteractive"'
			}
			If ($DeploymentType -eq "Uninstall")
			{
				Write-Host "UNINSTALL DEPLOYMENT TYPE: User is logged, but no processes are running, so run in Non-Interactive mode"
				Start-Process Deploy-Application.exe -Wait -ArgumentList '-DeployMode "NonInteractive" -DeploymentType "Uninstall"'
			}
		}
	}
}

Write-Output "Install Exit Code = $LASTEXITCODE"
Stop-Transcript
Exit $LASTEXITCODE