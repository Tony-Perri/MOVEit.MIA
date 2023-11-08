# MOVEit.MIA
MOVEit.MIA is a PowerShell module for using the [MOVEit Automation REST API](https://docs.ipswitch.com/MOVEit/Automation2023/API/REST-API/index.html).  *Please note: This is currently a work-in-progress and not all endpoints have been implemented.*

## Features
- Powershell commands map, as much as possible, directly to REST API endpoints.
- Commands set the type on output objects for formatting using .format.ps1xml files.
- Automatically refreshes the auth token when it is within 30 seconds of expiring.
- Supports the REST API paging parameters.
- Supports `-Verbose` for additional troubleshooting.

## Installation
MOVEit.MIA can be installed from the PowerShell Gallery using the command:
```powershell
Install-Module -Name MOVEit.MIA -Scope AllUsers
```
## Getting Started
Once installed, you should be able to access the MOVEit Automation REST API using the module commands either from a command-prompt or a script.

First, you'll need to connect to a MOVEit Automation server and authenticate:
```powershell
Connect-MIAServer -Hostname '<your-automation-server' -Credential (Get-Credential)
```
You can also just supply the username and get prompted for the password:
```powershell
Connect-MIAServer -Hostname '<your-automation-server' -Credential '<your-username>'
```
To avoid being prompted for credentials every time, do something like:
```powershell
$params = @{
    Hostname    = '<your-automation-server>'
    Credential  = [pscredential]::new('<your-username>',
                    (ConvertTo-SecureString '<your-password>' -AsPlainText))
}

Connect-MIAServer @params
```
As of v0.3.3, for testing purposes, if you are using PowerShell 7, you can use the `-SkipCertificateCheck` parameter to avoid TLS errors when using a test or self-signed certificate:
```powershell
Connect-MIAServer -Hostname '<your-automation-server' -Credential '<your-username>' -SkipCertificateCheck
```
Once connected, you can use any of the commands to invoke the cooresponding REST API endpoint.
```powershell
# Get a list of tasks
Get-MIATask
```
```powershell
# Get a list of tasks by name
Get-MIATask -Name *Test*
```
```powershell
# Get a specific task by taskId
Get-MIATask -TaskId 222222
```
## Paging
The MOVEit Automation REST API supports returning paged results.  Use the `-Page` and `-PerPage` parameters to return paged results.  Use the `-IncludePaging` parameter to include paging information in the output.
```powershell
# Get the first 10 hosts
Get-MIAHost -Page 1 -PerPage 10 -IncludePaging
```
## Reporting
The commands `Get-MIAReportTaskRun`, `Get-MIAReportFileActivity` and `Get-MIAReportAudit` support both a predicate or, for convenience, specific parameters that dynamically build the predicate.
```powershell
# Get 10 task run items using a predicate in rsql format
Get-MIAReportTaskRun -Predicate 'Status=in=("Success","Failure")' -MaxCount 10       
```
```powershell
#Get 100 task run items for today with a status of Success or Failure
Get-MIAReportTaskRun -StartTimeStart (Get-Date).Date -Status Success,Failure        
```
## Running tasks
The `Start-MIATask` and `Wait-MIATask` commands can be used to run a task and wait for it to complete.
```powershell
# Get the task by name
$task = Get-MIATask -Name 'RunFromAPI With Params'

# Parameters for the task
$taskParams = @{
    FilemaskFromAPI = '*.pdf'
}

# Start the task
$taskRun = $task | Start-MIATask -Params $taskParams

# Wait for the task to complete
$taskRunResults = $taskRun | Wait-MIATask -Timeout 30

if ($taskRunResults.IsComplete) {
    # Get the results of the taskrun
    $taskRun | Get-MIATaskRun | Format-Table
    # Print the File Activity result
    $taskRun | Get-MIAFileActivity -OrderBy 'LogStamp' -Action send | Format-Table
}
else {
    $taskRunResults
}
```
## Task Steps
The [PSCustomObject] for a Task is very nested, especially for an 'Advanced Task'.  Use the `Select-MIATaskStep` command to simplify accessing the task steps.
```powershell
# Select the steps (ie. Source, Destination, etc.) for $task
$task | Select-MIATaskStep

# Select the process steps and expand Process object
$task | Select-MIATaskStep -StepType Process -Expand
```

## Calling endpoints that are not implemented
Currently, not all REST API endpoints have a cooresponding command.  However, the `Invoke-MIARestMethod` can be used to call most any Get endpoint resource. _(Note: As of v0.3.4, the below endpoints have been implemented)._
```powershell
# Use Invoke-MIARestMethod to call endpoints that don't have a command
Invoke-MIARestMethod -Resource 'customscripts' -Query @{fields = 'ID,Name,Description'}
Invoke-MIARestMethod -Resource 'datelists' -Query @{fields = 'ID,Name,Description'}
Invoke-MIARestMethod -Resource 'globalparameters'
Invoke-MIARestMethod -Resource 'standardscripts' -Query @{fields = 'ID,Name,Description'}
Invoke-MIARestMethod -Resource 'usergroups'
```
## Troubleshooting
Use the `-Verbose` parameter with any command to get additional troubleshooting information.
```powershell
Get-MIATask -Verbose
```
Use the `Invoke-MIAWebRequest` method that works similar to `Invoke-MIARestMethod` but returns the raw, unparsed HTTP response.
```powershell
# Get the raw response to the 'tasks' endpoint
Invoke-MIAWebRequest -Resource 'tasks' -Verbose
```

## Multiple Contexts
Use the `-Context` parameter with the `Connect-MIAServer` and subsequent commands in order to connect to multiple MOVEit Automation servers in the same session.
```powershell
# Connect to the default server
Connect-MIAServer -Hostname '<your-automation-server' -Credential (Get-Credential)

# Connect to a second server
Connect-MIAServer -Hostname '<your-automation-server' -Credential (Get-Credential) -Context 'Backup'

# Get tasks from both
$contexts = 'Default', 'Backup'
$contexts | ForEach-Object { Get-MIATask -Context $_ }
```
