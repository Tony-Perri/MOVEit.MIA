#
# Module manifest for module 'MOVEit.MIA'
#
# Generated by: perri
#
# Generated on: 3/21/2021
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'MOVEit.MIA.psm1'

# Version number of this module.
ModuleVersion = '0.3.2'

# Supported PSEditions
CompatiblePSEditions = @('Desktop','Core')

# ID used to uniquely identify this module
GUID = '69515c9e-406c-48e7-8847-298381c1beae'

# Author of this module
Author = 'Tony Perri'

# Company or vendor of this module
# CompanyName = 'Unknown'

# Copyright statement for this module
Copyright = '(c) Tony Perri. All rights reserved.'

# Description of the functionality provided by this module
Description = @'
PowerShell Module for accessing the MOVEit Automation REST API

For more information on the MOVEit Automation REST API, please visit the following:
https://docs.ipswitch.com/MOVEit/Automation2020/API/REST-API/index.html
'@

# Minimum version of the PowerShell engine required by this module
PowerShellVersion = '5.1'

# Name of the PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# ClrVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
FormatsToProcess = @('MOVEit.MIA.Format.ps1xml')

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @(
    'Get-MIAAudit'
    'Get-MIAFileActivity'
    'Get-MIATaskRun'
    'Connect-MIAServer'
    'Disconnect-MIAServer'
    'Get-MIACustomScript'
    'Get-MIAHost'
    'Get-MIAInfo'
    'Get-MIAPgpKey'
    'Get-MIAReportAudit'
    'Get-MIAReportFileActivity'
    'Get-MIAReportTaskRun'
    'Get-MIASshKey'
    'Get-MIASSLCert'
    'Get-MIATask'
    'Get-MIATaskLog'
    'Invoke-MIARestMethod'
    'New-MIATask'
    'Remove-MIATask'
    'Set-MIATask'
    'Start-MIATask'
    'Wait-MIATask'
    'Invoke-MIAWebRequest'
)

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @('Get-MIATaskRun','Get-MIAFileActivity','Get-MIAAudit')

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        # Tags = @()

        # A URL to the license for this module.
        # LicenseUri = ''

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/Tony-Perri/MOVEit.MIA'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

        # Prerelease string of this module
        # Prerelease = 'alpha'

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

