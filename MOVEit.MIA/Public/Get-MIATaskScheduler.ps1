function Get-MIATaskScheduler {
    <#
    .SYNOPSIS
        Get MOVEit Automation Task Scheduler status
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
        $resource = "tasks/scheduler"
                    
        # Send the request and output the response
        Invoke-MIARequest -Resource $resource -Context $Context
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}