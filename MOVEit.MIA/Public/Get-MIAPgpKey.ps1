function Get-MIAPgpKey {
    <#
        .SYNOPSIS
        Get MOVEit Automation PGP Key(s)
    #>
    [CmdletBinding(DefaultParameterSetName='List')]
    [OutputType('MOVEit.MIA.PgpKey')]
    param (
        [Parameter(Mandatory,
                    Position = 0,
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName,
                    ParameterSetName='Detail')]
        [ValidateNotNullOrEmpty()]                    
        [string]$PgpKeyId,

        [Parameter(ParameterSetName='List')]
        [string]$Uid,

        [Parameter(ParameterSetName='List')]
        [ValidateSet('ID','uid','PubPriv','KeyType','KeyLength',
                    'Expired','Revoked','Disabled','Created','Expires',
                    'Status','Fingerprint','SymAlg','xInExpirationRange',
                    IgnoreCase = $false)]
        [string[]]$Fields,

        [Parameter(ParameterSetName='List')]
        [int32]$Page,

        [Parameter(ParameterSetName='List')]
        [int32]$PerPage,
        
        [Parameter(ParameterSetName='List')]                         
        [switch]$IncludePaging,

        # Context
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$Context = $script:DEFAULT_CONTEXT
    )

    begin {
        # Set the resource for this request
        $resource = "pgpkeys"

        # Set the typename for the output
        $typeName = 'MOVEit.MIA.PgpKey'
    }
    
    process {
        try {   
            # Send the request and write the response
            switch ($PSCmdlet.ParameterSetName) {
                'Detail' {
                    Invoke-MIARequest -Resource "$resource/$PGPKeyId" -Context $Context |
                        Write-MIAResponse -TypeName $typeName
                }
                'List' {
                    $query = @{}
                    switch ($PSBoundParameters.Keys) {
                        Uid     { $query['uid']     = $Uid }
                        Fields  { $query['fields']  = $Fields -join ',' }
                        Page    { $query['page']    = $Page }
                        PerPage { $query['perPage'] = $PerPage }
                    }
                    Invoke-MIARequest -Resource "$resource" -Body $query -Context $Context |
                        Write-MIAResponse -Typename $typeName -IncludePaging:$IncludePaging
                }
            }
        }
        catch {
            $PSCmdLet.ThrowTerminatingError($PSItem)
        }
    }
}