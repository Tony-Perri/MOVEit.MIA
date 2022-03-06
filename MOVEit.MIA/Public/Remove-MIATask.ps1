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
        # Confirm the Token, refreshing if necessary
        Confirm-MIAToken -Context $Context

        # Get the context
        $ctx = Get-MIAContext -Context $Context
        
        # Build the request
        $params = @{
            Uri = "$($ctx.BaseUri)/tasks/$TaskId"
            Method = 'Delete'
            Headers = @{
                Accept = 'application/json'
                Authorization = "Bearer $($ctx.Token.AccessToken)"
            }            
        }

        # Invoke the request
        $response = Invoke-RestMethod @params
        $response
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }    
}