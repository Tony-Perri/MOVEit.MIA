function Confirm-MIAToken {
    <#
    .SYNOPSIS
        Confirm an auth token, refresh if necessary.
    .DESCRIPTION
        Determines if the token is expired or expiring within 30 seconds.
        Refreshes an auth token using the /api/v1/token endpoint.
        Called from the Get-MIA* commands.            
    .INPUTS
        None.
    .OUTPUTS
        None.
    .LINK
        See link for /api/v1/token doc.
        https://docs.ipswitch.com/MOVEit/Automation2020/API/REST-API/index.html#_authrequestauthtokenusingpost
    #>    
    [CmdletBinding()]
    param (
        # Context
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Context
    )

    try {
        # Get the context
        $ctx = $script:Context[$Context]

        # Check to see if Connect-MIAServer has been called and exit with an error
        # if it hasn't.
        if (-not $ctx.BaseUri) {
            Write-Error "[$Context]: BaseUri is invalid.  Try calling Connect-MIAServer first." -ErrorAction Stop
        }

        # Determine how close the token is to expiring
        $elapsed = New-TimeSpan -Start $ctx.Token.CreatedAt
        Write-Verbose "[$Context]: MIA Token at $($elapsed.TotalSeconds.ToString('F0')) of $($ctx.Token.ExpiresIn) seconds"

        # If the key is within 30 seconds of expiring, let's go ahead and
        # refresh it.
        if ($elapsed.TotalSeconds -gt $ctx.Token.ExpiresIn - 30) {

            Write-Verbose "[$Context]: MIA Token expired, refreshing..."

            $params = @{
                Uri = "$($ctx.BaseUri)/token"
                Method = 'POST'
                ContentType = 'application/x-www-form-urlencoded'
                Body = "grant_type=refresh_token&refresh_token=$($ctx.Token.RefreshToken)"
                Headers = @{Accept = "application/json"}
            }
            
            $response = Invoke-RestMethod @params
            if ($response.access_token) {
                $ctx.Token = @{                    
                    AccessToken = $Response.access_token
                    CreatedAt = $(Get-Date)
                    ExpiresIn = $Response.expires_in
                    RefreshToken = $Response.refresh_token
                }

                # Update the script variable with the updated context
                $script:Context[$Context] = $ctx
                
                Write-Verbose "[$Context]: MIA Token refreshed for access to $($ctx.BaseUri)"
            }        
        }
    }
    catch {
        Write-Verbose "[$Context]: MIA Token not refreshed"

        # Clear the saved Token
        $ctx.Token = @()

        # Clear the saved Base Uri
        $ctx.BaseUri = ''

        # Update the script variable with the updated context
        $script:Context[$Context] = $ctx

        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}