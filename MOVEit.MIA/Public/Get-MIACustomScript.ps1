function Get-MIACustomScript {
    <#
        .SYNOPSIS
        Get a MOVEit Automation Custom Script(s)
    #>
    [CmdletBinding(DefaultParameterSetName='List')]
    [OutputType('MOVEit.MIA.CustomScript')]
    param (
        [Parameter(Mandatory,
                    Position = 0,
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName,
                    ParameterSetName='Detail')]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [string]$ScriptId,

        [Parameter(ParameterSetName='List')]
        [string]$Name,

        [Parameter(ParameterSetName='List')]
        [ValidateSet('ID','Name','Description','Source',
                    'Lang', IgnoreCase = $false)]
        [string[]]$Fields,

        [Parameter(ParameterSetName='List')]
        [int32]$Page,

        [Parameter(ParameterSetName='List')]
        [int32]$PerPage,

        [Parameter(ParameterSetName='List')]                         
        [switch]$IncludePaging,

        # Context
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Context = $script:DEFAULT_CONTEXT
    )

    begin {
        # Set the resource for this request
        $resource = "customscripts"

        # Set the typename for the output
        $typeName = 'MOVEit.MIA.CustomScript'
    }
    
    process {
        try {   
            # Send the request and write the response
            switch ($PSCmdlet.ParameterSetName) {
                'Detail' {
                    Invoke-MIARequest -Resource "$resource/$ScriptId" -Context $Context |
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
                    Invoke-MIARequest -Resource "$resource" -Context $Context -Body $query |
                        Write-MIAResponse -Typename $typeName -IncludePaging:$IncludePaging
                }
            }
        }
        catch {
            $PSCmdLet.ThrowTerminatingError($PSItem)
        }
    }
}