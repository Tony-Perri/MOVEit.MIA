function Get-MIAInfo {
    <#
    .SYNOPSIS
        Get MOVEit Automation Server Info
    #>
    [CmdletBinding()]
    param (
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
    
        # Set the Uri for this request
        $uri = "$($ctx.BaseUri)/info"
                    
        # Set the request headers
        $headers = @{
            Accept = "application/json"
            Authorization = "Bearer $($ctx.Token.AccessToken)"
        } 

        # Send the request and output the response
        $response = Invoke-RestMethod -Uri $uri -Headers $headers
        $response | Write-MIAResponse -TypeName 'MIAInfo' 
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}