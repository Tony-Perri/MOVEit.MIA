function Get-MIAReportTaskRun {
    <#
    .SYNOPSIS
        Get TaskRun log/report.
    .DESCRIPTION
        Get TaskRun log/report using the /api/v1/reports/taskruns endpoint.
        Call Connect-MIAServer before calling this function
    .EXAMPLE
        Get-MIAReportTaskRun
        Get 100 task run items using default query
    .EXAMPLE
        Get-MIAReportTaskRun -Predicate 'Status=in=("Success","Failure")' -MaxCount 10
        Get 10 task run items using a predicate in rsql format
    .EXAMPLE
        Get-MIAReportTaskRun -StartTimeStart (Get-Date).Date -Status Success,Failure
        Get 100 task run items for today with a status of Success or Failure
    .INPUTS
        None.
    .OUTPUTS
        Collection of task run records as custom MOVEit.MIA.ReportTaskRun objects.
    .LINK
        See link for /api/v1/reports/taskruns doc.
        https://docs.ipswitch.com/MOVEit/Automation2023/API/REST-API/index.html#_gettaskrunsreportusingpost.
    .NOTES
        Calls Confirm-MIAToken to auto-refresh token.
        Use -verbose parameter to see the rsql predicate.        
    #>
    [CmdletBinding(DefaultParameterSetName='Predicate')]
    [OutputType('MOVEit.MIA.ReportTaskRun')]
    param (
        # predicate for REST call
        [Parameter(Mandatory=$false, ParameterSetName='Predicate')]
        [ValidateNotNullOrEmpty()]
        [string]$Predicate = 'Status=in=("Success","Failure")',

        # Parameters for a specific task run
        [Parameter(Mandatory=$false,
                    ValueFromPipelineByPropertyName,
                    ParameterSetName='BuildRsql')]
        [ValidateNotNullOrEmpty()]
        [string]$TaskId,

        # Parameters for a specific task run
        [Parameter(Mandatory=$false,
                    ValueFromPipelineByPropertyName,
                    ParameterSetName='BuildRsql')]
        [ValidateNotNullOrEmpty()]
        [string]$NominalStart,

        # Filter by taskname ==, =like=. Accepts * and ? for wildcards.
        # Filter by tasknames =in=.
        [Parameter(Mandatory=$false, ParameterSetName='BuildRsql')]
        [ValidateNotNullOrEmpty()]
        [string[]]$Taskname,

        # Filter by status(s) ==, =in=
        [Parameter(Mandatory=$false, ParameterSetName='BuildRsql')]
        [ValidateSet('Success', 'Failure', 'No xfers')]
        [string[]]$Status,

        # Filter by startTime =gt=
        [Parameter(Mandatory=$false, ParameterSetName='BuildRsql')]
        [ValidateNotNullOrEmpty()]
        [datetime]$StartTimeStart,

        # Filter by startTime =le=
        [Parameter(Mandatory=$false, ParameterSetName='BuildRsql')]
        [ValidateNotNullOrEmpty()]
        [datetime]$StartTimeEnd,

        # Filter by filesSent =ge=
        [Parameter(Mandatory=$false, ParameterSetName='BuildRsql')]
        [ValidateNotNullOrEmpty()]
        [int]$FilesSent,

        # Filter by totalBytesSent =ge=
        [Parameter(Mandatory=$false, ParameterSetName='BuildRsql')]
        [ValidateNotNullOrEmpty()]
        [int64]$TotalBytesSent,

        # orderBy for REST call
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$OrderBy = '!StartTime',

        #maxCount for REST call
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
                TaskId {
                    'TaskId=="{0}"' -f $TaskId
                }
                NominalStart {
                    'NominalStart=="{0}"' -f $NominalStart
                }
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
                Status {
                    if ($Status.Count -gt 1) {
                        'Status=in=("{0}")' -f ($Status -join '","')
                    }
                    else {
                        'Status=="{0}"' -f $Status
                    }
                }
                StartTimeStart {
                    'StartTime=ge={0:yyyy-MM-ddTHH:mm:ss}' -f $StartTimeStart
                }
                StartTimeEnd {
                    'StartTime=lt={0:yyyy-MM-ddTHH:mm:ss}' -f $StartTimeEnd
                }
                FilesSent {
                    'FilesSent=ge={0}' -f $FilesSent
                }   
                TotalBytesSent {
                    'TotalBytesSent=ge={0}' -f $TotalBytesSent
                }                                 
            } ) -join ';'
    }
    
    Write-Verbose $Predicate
    
    try {        
        # Build the request body
        $body = @{
            predicate   = "$Predicate";
            orderBy     = "$OrderBy";
            maxCount    = "$MaxCount"
        } | ConvertTo-Json

        # Build the request
        $params = @{
            Resource    = "reports/taskruns"
            Method      = 'Post'
            ContentType = 'application/json'
            Body        = $body
            Context     = $Context
        }
        
        # Invoke the request and write out the response
        Invoke-MIARequest @params |
            Write-MIAResponse -TypeName 'MOVEit.MIA.ReportTaskRun'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}