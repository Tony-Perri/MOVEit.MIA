function New-MIATask {
    <#
    .SYNOPSIS
        Create a MOVEit Automation task
    #>
    [CmdletBinding()]
    [OutputType('MOVEit.MIA.Task')]
    param (
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
                Resource    = "$resource"
                Method      = 'Post'
                ContentType = 'application/json'
            }

            # Blank the TaskId if it exists to be safe
            if ($task.psobject.properties['Id']) {
                $task.ID = ''
            }

            # Build the request body
            $body = $Task | ConvertTo-Json -Depth 20

            # Invoke the request
            Invoke-MIARequest @params -Body $body -Context $Context |
                Write-MIAResponse -Typename $typeName
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}