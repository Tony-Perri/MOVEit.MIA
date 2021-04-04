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
        # Confirm the Token, refreshing if necessary
        Confirm-MIAToken -Context $Context
        
        # Get the context
        $ctx = Get-MIAContext -Context $Context

        # Set the Uri for this request
        $uri = "$($ctx.BaseUri)/tasks"
                    
        # Set the request headers
        $headers = @{
            Accept = "application/json"
            Authorization = "Bearer $($ctx.Token.AccessToken)"
        } 

        # Setup the params to splat to IRM
        $irmParams = @{
            Uri = "$uri/$TaskId/start"
            Method = 'Post'
            Headers = $headers
            ContentType = 'application/json'
            Body = ($Params | ConvertTo-Json)
        }

        # Send the request and write out the response
        $response = Invoke-RestMethod @irmParams

        # Add the TaskId to the response to facilitate piping to other commands
        $response | Add-Member -MemberType NoteProperty -Name taskId -Value $TaskId
        Write-Host "Task $TaskId started at $($response.nominalStart)"
        Write-Output $response
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}