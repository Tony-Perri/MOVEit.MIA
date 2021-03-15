function Invoke-MIARestMethod {
    <#
    .SYNOPSIS
        Cmdlet for invoking MOVEit Automation REST methods that
        there isn't a wrapper for yet.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,
                    Position=1)]
        [string]$Resource,

        [Parameter(Mandatory=$false)]
        [hashtable]$Query,

        [Parameter(Mandatory=$false)]
        [switch]$IncludePaging
    )

    # Check to see if Connect-MIAServer has been called and exit with an error
    # if it hasn't.
    if (-not $script:BaseUri) {
        Write-Error "BaseUri is invalid.  Try calling Connect-MIAServer first."
        return        
    }

    # Set the Uri for this request
    $uri = "$script:BaseUri/$Resource"
                
    # Set the request headers
    $headers = @{
        Accept = "application/json"
        Authorization = "Bearer $($script:Token.AccessToken)"
    } 

    # Additonal params that will be splatted
    $irmParams = @{}
    if ($Query) { $irmParams['Body'] = $Query}

    try {
        # Confirm the Token, refreshing if necessary
        Confirm-MIAToken

        $response = Invoke-RestMethod -Uri $uri -Headers $headers @irmParams
        $response | Write-MIAResponse -TypeName 'MIAGeneric' -IncludePaging:$IncludePaging
    }
    catch {
        $_
    }
    
}