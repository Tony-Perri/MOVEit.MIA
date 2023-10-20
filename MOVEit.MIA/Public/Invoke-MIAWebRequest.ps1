function Invoke-MIAWebRequest {
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

        # Context
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$Context = $script:DEFAULT_CONTEXT
    )

    try {
        # Confirm the Token, refreshing if necessary
        Confirm-MIAToken -Context $Context

        # Get the context
        $ctx = $script:Context[$Context]

        # Set the Uri for this request
        $uri = "$($ctx.BaseUri)/$Resource"
                    
        # Set the request headers
        $headers = @{
            Accept = "application/json"
            Authorization = "Bearer $($ctx.Token.AccessToken)"
        } 

        # Additonal params that will be splatted
        $irmParams = @{}
        if ($Query) { $irmParams['Body'] = $Query}

        # Add SkipCertificateCheck parameter if set
        if ($ctx.SkipCertificateCheck) {
            $irmParams['SkipCertificateCheck'] = $true
            Write-Verbose "SkipCertificateCheck: $true"
        }
        
        # If this is PowerShell 7, lets add the -SkipHttpErrorCheck param
        if ($PSVersionTable.PSVersion.Major -ge 7) { $irmParams['SkipHttpErrorCheck'] = $true}

        Invoke-WebRequest -Uri $uri -Headers $headers @irmParams
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
    
}