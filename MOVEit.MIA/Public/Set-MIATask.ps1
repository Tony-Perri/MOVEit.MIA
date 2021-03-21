function Set-MIATask {
    <#
        .SYNOPSIS
        Update a MOVEit Automation Task
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                    ValueFromPipelineByPropertyName)]
        [Alias('Id')]                    
        [string]$TaskId,

        [Parameter(Mandatory,
                    ValueFromPipeline)]
        [psobject]$Task
    )

    try {        
        # Confirm the Token, refreshing if necessary
        Confirm-MIAToken
        
        # Build the request
        $params = @{
            Uri = "$script:BaseUri/tasks/$TaskId"
            Method = 'Put'
            Headers = @{
                Accept = 'application/json'
                Authorization = "Bearer $($script:Token.AccessToken)"
            }
            ContentType = 'application/json'
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