function Get-MIAReportFileActivity {
    <#
    .SYNOPSIS
        Get FileActivity log/report.
    .DESCRIPTION
        Get FileActivity log/report using the /api/v1/reports/fileactivity endpoint.
        Call Connect-MIAServer before calling this function
    .EXAMPLE
        Get-MIAReportFileActivity
        Get 100 file activity items using default query
    .EXAMPLE
        Get-MIAReportFileActivity -Predicate "statuscode==0" -MaxCount 10
        Get 10 file activity items using a predicate in rsql format
    .EXAMPLE
        Get-MIAReportFileActivity -LogStampStart (Get-Date).Date -Status Success
        Get 100 file activity items for today with a status of Success
    .INPUTS
        None.
    .OUTPUTS
        Collection of file activity records as custom MIAReportFileActivity objects.
    .LINK
        See link for /api/v1/reports/fileactivity doc.
        https://docs.ipswitch.com/MOVEit/Automation2020/API/REST-API/index.html#_getfileactivityreportusingpost.
    .NOTES
        Calls Confirm-MIAToken to auto-refresh token.
        Use -verbose parameter to see the rsql predicate.        
    #>
    [CmdletBinding(DefaultParameterSetName='Predicate')]
    param (
        # predicate for REST call
        [Parameter(Mandatory=$false, ParameterSetName='Predicate')]
        [ValidateNotNullOrEmpty()]
        [string]$Predicate = 'StatusCode=out=("5000","5001")',

        # Filter by taskname(s) ==, =like=, =in=
        [Parameter(Mandatory=$false, ParameterSetName='BuildRsql')]
        [ValidateNotNullOrEmpty()]
        [string[]]$Taskname,

        # Filter by statuscode ==0, !=0
        [Parameter(Mandatory=$false, ParameterSetName='BuildRsql')]
        [ValidateSet('Success', 'Failure')]
        [string]$Status,
        
        # Filter by logStamp =ge=
        [Parameter(Mandatory=$false, ParameterSetName='BuildRsql')]
        [ValidateNotNullOrEmpty()]
        [datetime]$LogStampStart,

        # Filter by logStamp =lt=
        [Parameter(Mandatory=$false, ParameterSetName='BuildRsql')]
        [ValidateNotNullOrEmpty()]
        [datetime]$LogStampEnd,
        
        # Filter by action(s) ==, =in=
        [Parameter(Mandatory=$false, ParameterSetName='BuildRsql')]
        [ValidateSet('get','process', 'send', 'delete', 'rename', 'mkdir')]
        [string[]]$Action,

        # orderBy for REST call
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$OrderBy = '!LogStamp',

        # maxCount for REST call
        [Parameter(Mandatory=$false)]
        [ValidateRange(1, 100000)]
        [int32]$MaxCount = 100
    )
    
    # Build the predicate based on the params passed in if
    # the BuildRsql param set was used.
    if ($PSCmdlet.ParameterSetName -eq 'BuildRsql') {         
        $Predicate = $(
            switch ($PSBoundParameters.Keys) {
                Taskname {
                    if ($Taskname.Count -gt 1) {
                        'Taskname=in=("{0}")' -f ($Taskname -join '","')
                    }
                    elseif ($Taskname -match '[\*\?]') {                        
                        'Taskname=like="{0}"' -f $Taskname -replace '\*', '%' -replace '\?', '_'
                    }
                    else {
                        'Taskname=="{0}"' -f $Taskname
                    }
                }
                LogStampStart {
                    'LogStamp=ge={0:yyyy-MM-ddTHH:mm:ss}' -f $LogStampStart
                }
                LogStampEnd {
                    'LogStamp=lt={0:yyyy-MM-ddTHH:mm:ss}' -f $LogStampEnd
                }
                Status {
                    if ($Status -eq 'Success') {
                        'StatusCode==0'
                    }
                    elseif ($Status -eq 'Failure') {
                        'StatusCode!=0'
                    }
                }
                Action {
                    if ($Action.Count -gt 1) {
                        'Action=in=({0})' -f ($Action -join '","')
                    }
                    else {
                        'Action=={0}' -f $Action
                    }
                }
            } ) -join ';'
    }

    Write-Verbose $Predicate

    try {
        # Confirm the token, refreshing if necessary
        Confirm-MIAToken

        # Build the request
        $params = @{
            Uri = "$script:BaseUri/reports/fileactivity"
            Method = 'Post'
            Headers = @{
                Accept = 'application/json'
                Authorization = "Bearer $($script:Token.AccessToken)"
            }
            ContentType = 'application/json'
        }

        # Build the request body
        $body = @{
            predicate = "$Predicate"
            orderBy = "$OrderBy"
            maxCount = "$MaxCount"
        } | ConvertTo-Json

        # Invoke the request
        $response = Invoke-RestMethod @params -Body $body
        
        # Add type to the items for better display from .format.ps1xml file and write
        # to the pipeline
        $response.items | foreach-object { $_.PSOBject.TypeNames.Insert(0, 'MIAReportFileActivity'); $_ }
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}