function Get-MIAResourceGroupAcl {
    <#
        .SYNOPSIS
        Get a MOVEit Automation Resource Group ACL(s)
    #>    
    [CmdletBinding(DefaultParameterSetName='List')]
    [OutputType('MOVEit.MIA.ResourceGroupAcl')]
    param (
        [Parameter(Mandatory,
                    Position = 0,
                    ValueFromPipeline,
                    ValueFromPipelineByPropertyName,
                    ParameterSetName='Detail')]
        [string]$AclId,

        [Parameter(ParameterSetName='List')]                    
        [string]$ResourceGroupName,
        
        [Parameter(ParameterSetName='List')]                    
        [string]$UserGroupName,

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
        $resource = "resourcegroups/acls"

        # Set the typeName for the response
        $typeName = 'MOVEit.MIA.ResourceGroupAcl'
    }

    process {
        try {
            # Send the request and write the response
            switch ($PSCmdlet.ParameterSetName) {
                'Detail' {
                    Invoke-MIARequest -Resource "$resource/$AclId" -Context $Context |
                        Write-MIAResponse -TypeName $typeName
                }
                'List' {
                    $query = @{}
                    switch ($PSBoundParameters.Keys) {
                        ResourceGroupName   { $query['resourceGroupName']   = $ResourceGroupName }
                        UserGroupName       { $query['userGroupName']       = $UserGroupName }
                        Fields              { $query['fields']              = $Fields -join ',' }
                        Page                { $query['page']                = $Page }
                        PerPage             { $query['perPage']             = $PerPage }
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