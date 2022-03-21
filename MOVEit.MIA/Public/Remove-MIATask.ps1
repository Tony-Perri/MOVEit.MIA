function Remove-MIATask {
    <#
        .SYNOPSIS
        Remove a MOVEit Automation Task
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                    ValueFromPipelineByPropertyName)]
        [Alias('Id')]                    
        [string]$TaskId,

        # Context
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$Context = $script:DEFAULT_CONTEXT
    )

    try {        
        # Build the request
        $params = @{
            Resource = "tasks/$TaskId"
            Method = 'Delete'
        }

        # Invoke the request
        Invoke-MIARequest @params -Context $Context
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }    
}