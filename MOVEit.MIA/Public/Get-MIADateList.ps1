function Get-MIADateList {
    <#
        .SYNOPSIS
        Get a MOVEit Automation Resource Group(s)
    #>
    [CmdletBinding(DefaultParameterSetName='List')]
    [OutputType('MOVEit.MIA.DateList')]
    param (
        [Parameter(Mandatory,
                    Position = 0,
                    ValueFromPipelineByPropertyName,
                    ParameterSetName='Detail')]
        [Alias('Id')]
        [string]$DateListId,

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
        $resource = "datelists"

        # Set the typeName for this response
        $typeName = 'MOVEit.MIA.DateList'
    }

    process {
        try {
            # Send the request and write the response
            switch ($PSCmdlet.ParameterSetName) {
                'Detail' {
                    Invoke-MIARequest -Resource "$resource/$DateListId" -Context $Context |
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
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}