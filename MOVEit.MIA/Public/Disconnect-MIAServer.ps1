function Disconnect-MIAServer {
    <#
    .SYNOPSIS
        Disconnect from a MOVEit Automation server.
    #>
    
    # Check to see if Connect-MIAServer has been called and exit with an error
    # if it hasn't.
    if (-not $script:BaseUri) {
        Write-Error "BaseUri is invalid.  Try calling Connect-MIAServer first."
        return        
    }

    # Set the Uri for this request
    $uri = "$script:BaseUri/token/revoke"
                
    # Set the request headers
    $headers = @{
        Accept = "application/json"
    } 

    # Build the request body
    $body = @{
        token = $script:Token.AccessToken
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
    try {
        # Confirm the token, refreshing if necessary
        Confirm-MIAToken
        
        $response = Invoke-RestMethod @irmParams
        Write-Output "Disconnected from MOVEit Automation server"
    }
    catch {
        $_
    }
    finally {        
        # Clear the saved Token
        $script:Token = @()

        # Clear the saved Base Uri
        $script:BaseUri = ''
    }
}