function Set-MIATask {
    <#
        .SYNOPSIS
        Update a MOVEit Automation Task
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                    ValueFromPipelineByPropertyName)]
        [Alias('Id')]                    
        [string]$TaskId,

        [Parameter(Mandatory,
                    ValueFromPipeline)]
        [psobject]$Task,

        # Context
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$Context = $script:DEFAULT_CONTEXT
    )

    try {        
        # Build the request
        $params = @{
            Resource = "tasks/$TaskId"
            Method = 'Put'
            ContentType = 'application/json'
            Body = ($Task | ConvertTo-Json -Depth 20)
        }

        # Invoke the request
        Invoke-MIARequest @params -Context $Context |
            Write-MIAResponse -Typename "MIATask"
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }    
}