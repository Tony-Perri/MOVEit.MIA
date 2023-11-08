function Get-MIAGlobalParameter {
    <#
        .SYNOPSIS
        Get a MOVEit Automation Global Parameter(s)
    #>
    [CmdletBinding(DefaultParameterSetName='List')]
    [OutputType('MOVEit.MIA.GlobalParameter')]
    param (
        [Parameter(Mandatory,
                    Position = 0,
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName,
                    ParameterSetName='Detail')]
        [ValidateNotNullOrEmpty()]                    
        [string]$GlobalParameterName,

        [Parameter(ParameterSetName='List')]                    
        [string]$Name,

        [Parameter(ParameterSetName='List')]
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
        $resource = "globalparameters"

        # Set the typename for the output
        $typeName = 'MOVEit.MIA.GlobalParameter'
    }

    process {
        try {                            
            # Send the request and write the response
            switch ($PSCmdlet.ParameterSetName) {
                'Detail' {
                    Invoke-MIARequest -Resource "$resource/$GlobalParameterName" -Context $Context |
                        Write-MIAResponse -TypeName $typeName
                }
                'List' {
                    $query = @{}
                    switch ($PSBoundParameters.Keys) {
                        Name    { $query['name']    = $Name }
                        Fields  { $query['fields']  = $Fields -join ',' }
                        Type    { $query['type']    = $Type }
                        Page    { $query['page']    = $Page }
                        PerPage { $query['perPage'] = $PerPage }
                    }
                    Invoke-MIARequest -Resource "$resource" -Body $query -Context $Context |
                        Write-MIAResponse -Typename $typeName -IncludePaging:$IncludePaging
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}