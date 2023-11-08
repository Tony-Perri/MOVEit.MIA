function Get-MIASshKey {
    <#
        .SYNOPSIS
        Get a MOVEit Automation SSH Key(s)
    #>
    [CmdletBinding(DefaultParameterSetName='List')]
    [OutputType('MOVEit.MIA.SshKey')]
    param (
        [Parameter(Mandatory,
                    Position = 0,
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName,
                    ParameterSetName='Detail')]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [string]$SSHKeyId,

        [Parameter(ParameterSetName='List')]
        [string]$Name,

        [Parameter(ParameterSetName='List')]
        [ValidateSet('ID','Name','Fingerprint','PublicKeySSH',
                    'PublicKeyOpenSSH', IgnoreCase = $false)]
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
        $resource = "sshkeys"

        # Set the typename for the output
        $typeName = 'MOVEit.MIA.SshKey'
    }

    process {
        try {   
            # Send the request and write the response
            switch ($PSCmdlet.ParameterSetName) {
                'Detail' {
                    Invoke-MIARequest -Resource "$resource/$SSHKeyId" -Context $Context |
                        Write-MIAResponse -TypeName $typeName
                }
                'List' {
                    $query = @{}
                    switch ($PSBoundParameters.Keys) {
                        Name    { $query['name']    = $Name }
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