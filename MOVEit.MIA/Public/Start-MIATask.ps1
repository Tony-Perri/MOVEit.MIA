function Start-MIATask {
    <#
        .SYNOPSIS
        Start a MOVEit Automation Task
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                    Position=0,
                    ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [string]$TaskId,

        [Parameter(Mandatory=$false)]
        [hashtable]$Params,

        # Context
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$Context = $script:DEFAULT_CONTEXT
    )
        
    try {
        # Setup the params to splat to IRM
        $irmParams = @{
            Resource = "tasks/$TaskId/start"
            Method = 'Post'
            ContentType = 'application/json'
            Body = ($Params | ConvertTo-Json)
        }

        # Send the request and write out the response
        $response = Invoke-MIARequest @irmParams -Context $Context

        # Add the TaskId to the response to facilitate piping to other commands
        $response | Add-Member -MemberType NoteProperty -Name taskId -Value $TaskId
        Write-Host "Task $TaskId started at $($response.nominalStart)"
        Write-Output $response
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}