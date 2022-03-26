function Stop-MIATask {
    <#
        .SYNOPSIS
        Stop a MOVEit Automation Task
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                    Position=0,
                    ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [string]$TaskId,

        [Parameter(Mandatory,
            ValueFromPipelineByPropertyName)]
        [string]$NominalStart,

        # Context
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$Context = $script:DEFAULT_CONTEXT
    )
        
    try {
        # Setup the params to splat to IRM
        $irmParams = @{
            Resource = "tasks/$TaskId/stop"
            Method = 'Post'
            ContentType = 'application/json'
            Body = ( @{nominalStart="$NominalStart"} | ConvertTo-Json )
        }

        # Send the request and write out the response
        Invoke-MIARequest @irmParams -Context $Context
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}