[CmdletBinding()]
param(

    [Parameter()]
    [string]$OSServerVersion,

    [Parameter()]
    [string]$OSServiceStudioVersion,

    [Parameter()]
    [string]$OSInstallDir="F:\OutSystems"
)

# -- Stop on any error
$ErrorActionPreference = 'Stop'

# -- PS Logging
Start-Transcript -Path "C:\windows\temp\transcript0.txt" -Append | Out-Null

# -- Disable windows defender realtime scan
Set-MpPreference -DisableRealtimeMonitoring $true | Out-Null

# Initialize and format the data disk
Get-Disk 2 | Initialize-Disk -PartitionStyle MBR -PassThru | New-Partition -UseMaximumSize -MbrType IFS -driveletter F | Format-Volume -FileSystem NTFS -Confirm:$false | Out-Null
$null = Get-PSDrive

# -- Import module from Powershell Gallery
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force | Out-Null
Install-Module Outsystems.SetupTools -Force | Out-Null
Import-Module Outsystems.SetupTools | Out-Null

# -- Install PreReqs
Install-OSServerPreReqs -MajorVersion "$(([System.Version]$OSServerVersion).Major).$(([System.Version]$OSServerVersion).Minor)" -Verbose | Out-Null

# -- Download and install OS Server and Dev environment from repo
Install-OSServer -Version $OSServerVersion -InstallDir $OSInstallDir -Verbose | Out-Null
Install-OSServiceStudio -Version $OSServiceStudioVersion -InstallDir $OSInstallDir -Verbose| Out-Null
