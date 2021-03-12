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
    )

    $elapsed = New-TimeSpan -Start $script:Token.CreatedAt
    Write-Verbose "MIA Token at $($elapsed.TotalSeconds.ToString('F0')) of $($script:Token.ExpiresIn) seconds"

    # If the key is within 30 seconds of expiring, let's go ahead and
    # refresh it.
    if ($elapsed.TotalSeconds -gt $script:Token.ExpiresIn - 30) {

        Write-Verbose "MIA Token expired, refreshing..."

        $params = @{
            Uri = "$script:BaseUri/token"
            Method = 'POST'
            ContentType = 'application/x-www-form-urlencoded'
            Body = "grant_type=refresh_token&refresh_token=$($script:Token.RefreshToken)"
            Headers = @{Accept = "application/json"}
        }
        
        $response = Invoke-RestMethod @params
        if ($response.access_token) {
            $script:Token = @{                    
                AccessToken = $Response.access_token
                CreatedAt = $(Get-Date)
                ExpiresIn = $Response.expires_in
                RefreshToken = $Response.refresh_token
            }
            Write-Verbose "MIA Token refreshed for access to $script:BaseUri"
        }        
    }
}