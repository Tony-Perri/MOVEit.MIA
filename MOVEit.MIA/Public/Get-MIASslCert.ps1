function Get-MIASSLCert {
    <#
        .SYNOPSIS
        Get a MOVEit Automation SSL Cert(s)
    #>
    [CmdletBinding(DefaultParameterSetName='List')]
    [OutputType('MOVEit.MIA.SslCert')]
    param (
        [Parameter(Mandatory,
                    Position = 0,
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName,
                    ParameterSetName='Detail')]
        [ValidateNotNullOrEmpty()]                    
        [string]$SSLCertificateThumbprint,

        [Parameter(ParameterSetName='List')]
        [string]$Issuer,

        [Parameter(ParameterSetName='List')]
        [ValidateSet('Store','IssuedTo','Issuer','SerialNum',
                    'ExpDate','ValidFromDate','SHA1Thumbprint',
                    'xIsExpired','xInExpirationRange', IgnoreCase = $false)]
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
        $resource = "sslcerts"

        # Set the typename for the output
        $typeName = 'MOVEit.MIA.SslCert'
    }

    process {
        try {   
            # Send the request and write the response
            switch ($PSCmdlet.ParameterSetName) {
                'Detail' {
                    Invoke-MIARequest -Resource "$resource/$SSLCertificateThumbprint" -Context $Context |
                        Write-MIAResponse -TypeName $typeName
                }
                'List' {
                    $query = @{}
                    switch ($PSBoundParameters.Keys) {
                        Issuer  { $query['issuer']  = $Issuer }
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