function Get-MIAInfo {
    <#
    .SYNOPSIS
        Get MOVEit Automation Server Info
    #>
    [CmdletBinding()]
    param (
    )

    # Check to see if Connect-MIAServer has been called and exit with an error
    # if it hasn't.
    if (-not $script:BaseUri) {
        Write-Error "BaseUri is invalid.  Try calling Connect-MIAServer first."
        return        
    }

    # Set the Uri for this request
    $uri = "$script:BaseUri/info"
                
    # Set the request headers
    $headers = @{
        Accept = "application/json"
        Authorization = "Bearer $($script:Token.AccessToken)"
    } 

    try {
        # Confirm the Token, refreshing if necessary
        Confirm-MIAToken
        
        $response = Invoke-RestMethod -Uri $uri -Headers $headers
        $response | Write-MIAResponse -TypeName 'MIAInfo' 
    }
    catch {
        $_
    }
}