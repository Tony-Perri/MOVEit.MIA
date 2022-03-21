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
        # Set the resource for this request
        $resource = "pgpkeys"

        # Send the request and write the response
        switch ($PSCmdlet.ParameterSetName) {
            'Detail' {
                Invoke-MIARequest -Resource "$resource/$PGPKeyId" -Context $Context |
                    Write-MIAResponse -TypeName 'MIAPgpKey'
            }
            'List' {
                $query = @{}
                switch ($PSBoundParameters.Keys) {
                    Uid { $query['uid'] = $Uid }
                    Fields { $query['fields'] = $Fields -join ',' }
                    Page { $query['page'] = $Page }
                    PerPage { $query['perPage'] = $PerPage }
                }
                Invoke-MIARequest -Resource "$resource" -Body $query -Context $Context |
                    Write-MIAResponse -Typename "MIAPgpKey" -IncludePaging:$IncludePaging
            }
        }
    }
    catch {
        $PSCmdLet.ThrowTerminatingError($PSItem)
    }
}