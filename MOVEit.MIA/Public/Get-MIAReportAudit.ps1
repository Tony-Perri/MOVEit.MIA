function Get-MIAReportAudit
{
    <#
    .SYNOPSIS
        Get Audit log/report.
    .DESCRIPTION
        Get Audit log/report using the /api/v1/reports/audit endpoint.
        Call New-MIAToken before calling this function
    .EXAMPLE
        Get-MIAReportAudit
        Get 100 audit items using default query
    .EXAMPLE
        Get-MIAReportAudit -Predicate "status=='failure'" -MaxCount 10
        Get 10 file activity items using a predicate in rsql format
    .EXAMPLE
        Get-MIAReportAudit -LogTimeStart (Get-Date).Date -Status Success
        Get 100 audit items for today with a status of Success
    .INPUTS
        None.
    .OUTPUTS
        Collection of audit records as custom MIAReportAudit objects.
    .LINK
        See link for /api/v1/reports/audit doc.
        https://docs.ipswitch.com/MOVEit/Automation2023/API/REST-API/index.html#_getauditreportusingpost
    .NOTES
        Calls Confirm-MIAToken to auto-refresh token.
        Use -verbose parameter to see the rsql predicate.        
    #>
    [CmdletBinding(DefaultParameterSetName='Predicate')]
    param (
        # predicate for REST call
        [Parameter(Mandatory=$false, ParameterSetName='Predicate')]
        [ValidateNotNullOrEmpty()]
        [string]$Predicate = 'Status=="Failure"',

        # Filter by status(s) ==, =in=
        [Parameter(Mandatory=$false, ParameterSetName='BuildRsql')]
        [ValidateSet('Success', 'Failure')]
        [string[]]$Status,
        
        # Filter by logTime =ge=
        [Parameter(Mandatory=$false, ParameterSetName='BuildRsql')]
        [ValidateNotNullOrEmpty()]
        [Alias('LogStampStart')]
        [datetime]$LogTimeStart,

        # Filter by logTime =lt=
        [Parameter(Mandatory=$false, ParameterSetName='BuildRsql')]
        [ValidateNotNullOrEmpty()]
        [Alias('LogStampEnd')]
        [datetime]$LogTimeEnd,
        
        # Filter by action(s) ==, =in=
        [Parameter(Mandatory=$false, ParameterSetName='BuildRsql')]
        #[ValidateSet()]
        [string[]]$Action,

        # orderBy for REST call
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$OrderBy = '!LogTime',

        # maxCount for REST call
        [Parameter(Mandatory=$false)]
        [ValidateRange(1, 100000)]
        [int32]$MaxCount = 100,

        # Context
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$Context = $script:DEFAULT_CONTEXT
    )
    
    # Build the predicate based on the params passed in if
    # the BuildRsql param set was used.
    if ($PSCmdlet.ParameterSetName -eq 'BuildRsql') {         
        $Predicate = $(
            switch ($PSBoundParameters.Keys) {
                LogTimeStart {
                    'LogTime=ge={0:yyyy-MM-ddTHH:mm:ss}' -f $LogTimeStart
                }
                LogTimeEnd {
                    'LogTime=lt={0:yyyy-MM-ddTHH:mm:ss}' -f $LogTimeEnd
                }
                Status {
                    if ($Status.Count -gt 1) {
                        'Status=in=("{0}")' -f ($Status -join '","')
                    }
                    else {
                        'Status=="{0}"' -f $Status
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
        # Build the request body
        $body = @{
            predicate = "$Predicate"
            orderBy = "$OrderBy"
            maxCount = "$MaxCount"
        } | ConvertTo-Json

        # Build the request
        $params = @{
            Resource = "reports/audit"
            Method = 'Post'
            ContentType = 'application/json'
            Body = $body
            Context = $Context
        }

        # Invoke the request and write out the response
        Invoke-MIARequest @params |
            Write-MIAResponse -TypeName 'MIAReportAudit'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}