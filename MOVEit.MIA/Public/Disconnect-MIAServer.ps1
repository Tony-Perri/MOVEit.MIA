function Disconnect-MIAServer {
    <#
    .SYNOPSIS
        Disconnect from a MOVEit Automation server.
    #>
    [CmdletBinding()]
    param (
        # Context
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$Context = $script:DEFAULT_CONTEXT
    )

    try {
        # Confirm the token, refreshing if necessary
        Confirm-MIAToken -Context $Context

        # Get the context
        $ctx = $script:Context[$Context]

        # Set the Uri for this request
        $uri = "$($ctx.BaseUri)/token/revoke"
                    
        # Set the request headers
        $headers = @{
            Accept = "application/json"
        } 

        # Build the request body
        $body = @{
            token = $ctx.Token.AccessToken
        }

        # Setup the params to splat to IRM
        $irmParams = @{
            Uri         = $uri
            Method      = 'Post'
            Headers     = $headers
            ContentType = 'application/x-www-form-urlencoded'
            Body        =  $body
        }

        # Send the request and output the response
        Invoke-RestMethod @irmParams | Out-Null
        Write-Output "[$Context]: Disconnected from MOVEit Automation server"
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
    finally {        
        # Clear the saved Token
        $ctx.Token = @()

        # Clear the saved Base Uri
        $ctx.BaseUri = ''

        # Update the script variable with the updated context
        $script:Context[$Context] = $ctx
    }
}