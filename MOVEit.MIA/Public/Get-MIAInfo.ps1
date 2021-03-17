function Get-MIAInfo {
    <#
    .SYNOPSIS
        Get MOVEit Automation Server Info
    #>
    [CmdletBinding()]
    param (
    )

    try {
        # Confirm the Token, refreshing if necessary
        Confirm-MIAToken
    
        # Set the Uri for this request
        $uri = "$script:BaseUri/info"
                    
        # Set the request headers
        $headers = @{
            Accept = "application/json"
            Authorization = "Bearer $($script:Token.AccessToken)"
        } 

        # Send the request and output the response
        $response = Invoke-RestMethod -Uri $uri -Headers $headers
        $response | Write-MIAResponse -TypeName 'MIAInfo' 
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}