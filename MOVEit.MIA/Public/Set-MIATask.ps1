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
        # Confirm the Token, refreshing if necessary
        Confirm-MIAToken -Context $Context

        # Get the context
        $ctx = Get-MIAContext -Context $Context
        
        # Build the request
        $params = @{
            Uri = "$($ctx.BaseUri)/tasks/$TaskId"
            Method = 'Put'
            Headers = @{
                Accept = 'application/json'
                Authorization = "Bearer $($ctx.Token.AccessToken)"
            }
            ContentType = 'application/json'
        }

        # Build the request body
        $body = $Task | ConvertTo-Json -Depth 10

        # Invoke the request
        $response = Invoke-RestMethod @params -Body $body
        $response | Write-MIAResponse -Typename "MIATask"
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }    
}