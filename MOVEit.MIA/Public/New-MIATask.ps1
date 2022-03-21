function New-MIATask {
    <#
    .SYNOPSIS
        Create a MOVEit Automation task
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                    ValueFromPipeline)]
        [psobject]$Task,

        # Context
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$Context = $script:DEFAULT_CONTEXT
    )

    try {        
        # Build the request
        $params = @{
            Resource = "tasks"
            Method = 'Post'
            ContentType = 'application/json'
        }

        # Blank the TaskId if it exists to be safe
        if ($task.psobject.properties['Id']) {
            $task.ID = ''
        }

        # Build the request body
        $body = $Task | ConvertTo-Json -Depth 10

        # Invoke the request
        Invoke-MIARequest @params -Body $body -Context $Context |
            Write-MIAResponse -Typename "MIATask"
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }     
}