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
        # Confirm the Token, refreshing if necessary
        Confirm-MIAToken -Context $Context

        # Get the context
        $ctx = Get-MIAContext -Context $Context
        
        # Build the request
        $params = @{
            Uri = "$($ctx.BaseUri)/tasks"
            Method = 'Post'
            Headers = @{
                Accept = 'application/json'
                Authorization = "Bearer $($ctx.Token.AccessToken)"
            }
            ContentType = 'application/json'
        }

        # Blank the TaskId if it exists to be safe
        if ($task.psobject.properties['Id']) {
            $task.ID = ''
        }

        # Build the request body
        $body = $Task | ConvertTo-Json -Depth 10

        # Invoke the request
        $response = Invoke-RestMethod @params -Body $body
        $response | Write-MIAResponse -Typename "MIATask"
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }     
}