function Remove-MIAResourceGroupAcl {
    <#
        .SYNOPSIS
        Remove a MOVEit Automation Resource Group Acl
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                    ValueFromPipelineByPropertyName)]
        [string]$AclId,

        # Context
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$Context = $script:DEFAULT_CONTEXT
    )

    process {
        try {        
            # Build the request
            $params = @{
                Resource = "resourcegroups/acls/$AclId"
                Method = 'Delete'
            }

            # Invoke the request
            Invoke-MIARequest @params -Context $Context
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }    
    }
}