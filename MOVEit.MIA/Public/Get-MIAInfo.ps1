function Get-MIAInfo {
    <#
    .SYNOPSIS
        Get MOVEit Automation Server Info
    #>
    [CmdletBinding()]
    [OutputType('MOVEit.MIA.Info')]
    param (
        # Context
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$Context = $script:DEFAULT_CONTEXT
    )

    try {
        # Set the resource for this request
        $resource = "info"
                    
        # Send the request and output the response
        Invoke-MIARequest -Resource $resource -Context $Context |
            Write-MIAResponse -TypeName 'MOVEit.MIA.Info' 
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}