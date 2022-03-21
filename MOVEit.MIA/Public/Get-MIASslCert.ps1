function Get-MIASSLCert {
    [CmdletBinding(DefaultParameterSetName='List')]
    param (
        [Parameter(Mandatory,
                    ParameterSetName='Detail')]
        [string]$SSLCertificateThumbprint,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [string]$Issuer,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [ValidateSet('Store','IssuedTo','Issuer','SerialNum',
                    'ExpDate','ValidFromDate','SHA1Thumbprint',
                    'xIsExpired','xInExpirationRange', IgnoreCase = $false)]
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
        $resource = "sslcerts"

        # Send the request and write the response
        switch ($PSCmdlet.ParameterSetName) {
            'Detail' {
                Invoke-MIARequest -Resource "$resource/$SSLCertificateThumbprint" -Context $Context |
                    Write-MIAResponse -TypeName 'MIASslCert'
            }
            'List' {
                $query = @{}
                switch ($PSBoundParameters.Keys) {
                    Issuer { $query['issuer'] = $Issuer }
                    Fields { $query['fields'] = $Fields -join ',' }
                    Page { $query['page'] = $Page }
                    PerPage { $query['perPage'] = $PerPage }
                }
                Invoke-MIARequest -Resource "$resource" -Body $query -Context $Context |
                    Write-MIAResponse -Typename "MIASslCert" -IncludePaging:$IncludePaging
            }
        }
    }
    catch {
        $PSCmdLet.ThrowTerminatingError($PSItem)
    }
}