function Stop-MIATaskScheduler {
    <#
    .SYNOPSIS
        Start MOVEit Automation Task Scheduler
    #>
    [CmdletBinding()]
    param (
        # Context
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$Context = $script:DEFAULT_CONTEXT
    )

    try {
        # Set the resource for this request
        $resource = "tasks/scheduler/stop"
                    
        # Send the request and output the response
        Invoke-MIARequest -Resource $resource -Method Put -Context $Context
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}