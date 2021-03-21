function Get-MIASshKey {
    [CmdletBinding(DefaultParameterSetName='List')]
    param (
        [Parameter(Mandatory,
                    ParameterSetName='Detail')]
        [string]$SSHKeyId,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [string]$Name,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [ValidateSet('ID','Name','Fingerprint','PublicKeySSH',
                    'PublicKeyOpenSSH', IgnoreCase = $false)]
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
        $uri = "$script:BaseUri/sshkeys"
        
        # Set the request headers
        $headers = @{
            Accept = "application/json"
            Authorization = "Bearer $($script:Token.AccessToken)"
        } 

        # Send the request and write the response
        switch ($PSCmdlet.ParameterSetName) {
            'Detail' {
                $response = Invoke-RestMethod -Uri "$uri/$SSHKeyId" -Headers $headers
                $response | Write-MIAResponse -TypeName 'MIASshKey'
            }
            'List' {
                $query = @{}
                switch ($PSBoundParameters.Keys) {
                    Name { $query['name'] = $Name }
                    Fields { $query['fields'] = $Fields -join ',' }
                    Page { $query['page'] = $Page }
                    PerPage { $query['perPage'] = $PerPage }
                }
                $response = Invoke-RestMethod -Uri "$uri" -Headers $headers -Body $query
                $response | Write-MIAResponse -Typename "MIASshKey" -IncludePaging:$IncludePaging
            }
        }
    }
    catch {
        $PSCmdLet.ThrowTerminatingError($PSItem)
    }
}