function Get-MIAPgpKey {
    <#
        .SYNOPSIS
        Get MOVEit Automation PGP Key(s)
    #>
    [CmdletBinding(DefaultParameterSetName='List')]
    param (
        [Parameter(Mandatory,
                    ParameterSetName='Detail')]
        [string]$PgpKeyId,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [string]$Uid,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [ValidateSet('ID','uid','PubPriv','KeyType','KeyLength',
                    'Expired','Revoked','Disabled','Created','Expires',
                    'Status','Fingerprint','SymAlg','xInExpirationRange',
                    IgnoreCase = $false)]
        [string[]]$Fields,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [int32]$Page,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [int32]$PerPage,
        
        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]                         
        [switch]$IncludePaging,

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
        $uri = "$($ctx.BaseUri)/pgpkeys"
        
        # Set the request headers
        $headers = @{
            Accept = "application/json"
            Authorization = "Bearer $($ctx.Token.AccessToken)"
        } 

        # Send the request and write the response
        switch ($PSCmdlet.ParameterSetName) {
            'Detail' {
                $response = Invoke-RestMethod -Uri "$uri/$PGPKeyId" -Headers $headers
                $response | Write-MIAResponse -TypeName 'MIAPgpKey'
            }
            'List' {
                $query = @{}
                switch ($PSBoundParameters.Keys) {
                    Uid { $query['uid'] = $Uid }
                    Fields { $query['fields'] = $Fields -join ',' }
                    Page { $query['page'] = $Page }
                    PerPage { $query['perPage'] = $PerPage }
                }
                $response = Invoke-RestMethod -Uri "$uri" -Headers $headers -Body $query
                $response | Write-MIAResponse -Typename "MIAPgpKey" -IncludePaging:$IncludePaging
            }
        }
    }
    catch {
        $PSCmdLet.ThrowTerminatingError($PSItem)
    }
}