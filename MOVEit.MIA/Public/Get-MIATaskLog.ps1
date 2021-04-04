function Get-MIATaskLog {
    <#
        .SYNOPSIS
        Get MOVEit Automation Task Log(s)
    #>
    [CmdletBinding(DefaultParameterSetName='List')]
    param (
        [Parameter(Mandatory,
                    ValueFromPipelineByPropertyName,
                    ParameterSetName='List')]
        [Parameter(Mandatory,
                    ParameterSetName='Detail')]
        [Alias('Id')]                    
        [string]$TaskId,

        [Parameter(Mandatory,
                    ParameterSetName='Detail')]
        [string]$TaskLogId,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [ValidateSet('id','taskId','startTime','exitStatus', IgnoreCase = $false)]                    
        [string[]]$Fields,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [int32]$Page,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [int32]$PerPage,
        
        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]   
        [switch]$IncludePaging,

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
        $uri = "$($ctx.BaseUri)/tasks/$TaskId/log"
                    
        # Set the request headers
        $headers = @{
            Accept = "application/json"
            Authorization = "Bearer $($ctx.Token.AccessToken)"
        }    

        # Send the request and write the response
        switch ($PSCmdlet.ParameterSetName) {
            'Detail' {
                # This request is for text/plain
                $headers['Accept'] = 'text/plain'
                
                $response = Invoke-RestMethod -Uri "$uri/$TaskLogId" -Headers $headers
                Write-Output $response
            }
            'List' {
                $query = @{}
                switch ($PSBoundParameters.Keys) {
                    Fields { $query['fields'] = $Fields -join ','}
                    Page { $query['page'] = $Page }
                    PerPage { $query['perPage'] = $PerPage }
                }
                $response = Invoke-RestMethod -Uri "$uri" -Headers $headers -Body $query 
                $response | Write-MIAResponse -Typename "MIATaskLog" -IncludePaging:$IncludePaging
            }
        }
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}