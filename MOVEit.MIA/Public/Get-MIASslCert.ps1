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
        [string[]]$Fields,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [int32]$Page,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [int32]$PerPage,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]                         
        [switch]$IncludePaging
    )

    try {   
        # Confirm the Token, refreshing if necessary
        Confirm-MIAToken
        
        # Set the Uri for this request
        $uri = "$script:BaseUri/sslcerts"
        
        # Set the request headers
        $headers = @{
            Accept = "application/json"
            Authorization = "Bearer $($script:Token.AccessToken)"
        } 

        # Send the request and write the response
        switch ($PSCmdlet.ParameterSetName) {
            'Detail' {
                $response = Invoke-RestMethod -Uri "$uri/$SSLCertificateThumbprint" -Headers $headers
                $response | Write-MIAResponse -TypeName 'MIASslCert'
            }
            'List' {
                $query = @{}
                switch ($PSBoundParameters.Keys) {
                    Issuer { $query['issuer'] = $Issuer }
                    Fields { $query['fields'] = $Fields -join ',' }
                    Page { $query['page'] = $Page }
                    PerPage { $query['perPage'] = $PerPage }
                }
                $response = Invoke-RestMethod -Uri "$uri" -Headers $headers -Body $query
                $response | Write-MIAResponse -Typename "MIASslCert" -IncludePaging:$IncludePaging
            }
        }
    }
    catch {
        $PSCmdLet.ThrowTerminatingError($PSItem)
    }
}