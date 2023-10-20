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
        [ValidateNotNullOrEmpty()]
        [string]$TaskId,

        [Parameter(Mandatory,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]            
        [string]$NominalStart,

        [Parameter()]
        [switch]$Force,

        # Context
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$Context = $script:DEFAULT_CONTEXT
    )
    
    # Place in a process block so if nothing is passed in, like via pipeline, the function doesn't try
    # to execute using missing data.
    process {
        try {
            # Setup the params to splat to IRM
            $irmParams = @{
                Resource = "tasks/$TaskId/stop"
                Method = 'Post'
                ContentType = 'application/json'
                Body = ( @{nominalStart="$NominalStart"} | ConvertTo-Json )
            }

            if ($Force) {
                # Use the v0 kill endpoint instead
                $irmParams.Resource = $irmParams.Resource -replace 'stop', 'kill'
                $irmParams['ApiVersion'] = 'v0'
            }

            # Send the request and write out the response
            Invoke-MIARequest @irmParams -Context $Context
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}