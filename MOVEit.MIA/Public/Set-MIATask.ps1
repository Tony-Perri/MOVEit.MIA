function Set-MIATask {
    <#
        .SYNOPSIS
        Update a MOVEit Automation Task
    #>
    [CmdletBinding()]
    [OutputType('MOVEit.MIA.Task')]
    param (
        [Parameter(Mandatory,
                    ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [string]$TaskId,
        
        [Parameter(Mandatory,
                    ValueFromPipeline)]
        [PSTypeName('MOVEit.MIA.Task')]
        [psobject]$Task,

        # Context
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Context = $script:DEFAULT_CONTEXT
    )

    begin {
        # Set the resource for this request
        $resource = 'tasks'

        # Set the typeName for the response
        $typeName = 'MOVEit.MIA.Task'
    }

    process {
        try {        
            # Build the request
            $params = @{
                Resource    = "$resource/$TaskId"
                Method      = 'Put'
                ContentType = 'application/json'
                Body        = ($Task | ConvertTo-Json -Depth 20)
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