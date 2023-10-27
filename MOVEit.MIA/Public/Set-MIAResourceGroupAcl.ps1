function Set-MIAResourceGroupAcl {
    <#
        .SYNOPSIS
        Update a MOVEit Automation Resource Group ACL
    #>
    [CmdletBinding()]
    [OutputType('MOVEit.MIA.ResourceGroupAcl')]
    param (
        [Parameter(Mandatory,
                    ValueFromPipelineByPropertyName)]                    
        [string]$AclId,

        [Parameter(Mandatory,
                    ValueFromPipeline,
                    ParameterSetName = 'Acl')]
        [PSTypeName('MOVEit.MIA.ResourceGroupAcl')]
        [PSObject]$Acl,

        [Parameter(Mandatory, ParameterSetName='Permissions')]
        [ValidateSet('TaskRun', 'TaskEditExisting', 'TaskAddEditDelete', 'HostAddEditDelete', 'ScriptAddEditDelete',
                    'SSLAddEditDelete', 'SSHAddEditDelete', 'PGPAddEditDelete')]
        [string[]]$Permissions,

        # Context
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$Context = $script:DEFAULT_CONTEXT
    )

    begin {
        # Set the resource for this request
        $resource = "resourcegroups/acls"

        # Set the typeName for the response
        $typeName = 'MOVEit.MIA.ResourceGroupAcl'

        if ($PSCmdlet.ParameterSetName -eq 'Permissions') {
            $Acl = [PSCustomObject]@{
                Permissions = [PSCustomObject]@{
                    TaskRun             = [int]($Permissions -contains 'TaskRun')
                    TaskEditExisting    = [int]($Permissions -contains 'TaskEditExisting')
                    TaskAddEditDelete   = [int]($Permissions -contains 'TaskAddEditDelete')
                    HostAddEditDelete   = [int]($Permissions -contains 'HostAddEditDelete')
                    ScriptAddEditDelete = [int]($Permissions -contains 'ScriptAddEditDelete')
                    SSLAddEditDelete    = [int]($Permissions -contains 'SSLAddEditDelete')
                    SSHAddEditDelete    = [int]($Permissions -contains 'SSHAddEditDelete')
                    PGPAddEditDelete    = [int]($Permissions -contains 'PGPAddEditDelete')
                }
            }
        }
    }

    process {
        try {                
            # Build the request
            $params = @{
                Resource = "$resource/$AclId"
                Method = 'Put'
                ContentType = 'application/json'
                Body = ($Acl | ConvertTo-Json -Depth 10)
            }

            # Invoke the request
            Invoke-MIARequest @params -Context $Context |
                Write-MIAResponse -Typename $typeName
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }    
    }
}