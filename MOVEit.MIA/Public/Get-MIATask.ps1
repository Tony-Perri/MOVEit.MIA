function Get-MIATask {
    <#
        .SYNOPSIS
        Get MOVEit Automation Task(s)
    #>
    [CmdletBinding(DefaultParameterSetName='List')]
    param (
        [Parameter(Mandatory,
                    Position=0,
                    ValueFromPipelineByPropertyName=$true,
                    ParameterSetName='Detail')]
        [Alias('Id')]
        [string]$TaskId,

        [Parameter(Mandatory,
                    ParameterSetName='Running')]
        [switch]$Running,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [Parameter(Mandatory=$false,
                    ParameterSetName='Running')]
        [string]$Name,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [Parameter(Mandatory=$false,
                    ParameterSetName='Running')]
        [ValidateSet('Group','ID','Name','Info','NextActions',
                    'Schedules','Scheduled','steps','Active','AR',
                    'CacheNames','NextEID','TT','UseDefStateCaching',
                    'Watched',IgnoreCase = $false)]     
        [string[]]$Fields,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [Parameter(Mandatory=$false,
                    ParameterSetName='Running')]
        [int32]$Page,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [Parameter(Mandatory=$false,
                    ParameterSetName='Running')]
        [int32]$PerPage,
        
        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]   
        [Parameter(Mandatory=$false,
                    ParameterSetName='Running')]                         
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
        $uri = "$($ctx.BaseUri)/tasks"
                    
        # Set the request headers
        $headers = @{
            Accept = "application/json"
            Authorization = "Bearer $($ctx.Token.AccessToken)"
        }    
        
        # Send the request and write the response
        switch ($PSCmdlet.ParameterSetName) {
            'Detail' {
                $response = Invoke-RestMethod -Uri "$uri/$TaskId" -Headers $headers
                $response | Write-MIAResponse -TypeName 'MIATaskDetail'
            }
            'Running' {
                $query = @{}
                switch ($PSBoundParameters.Keys) {
                    Name { $query['name'] = $Name }
                    Fields { $query['fields'] = $Fields -join ',' }
                    Page { $query['page'] = $Page }
                    PerPage { $query['perPage'] = $PerPage }
                }
                $response = Invoke-RestMethod -Uri "$uri/running" -Headers $headers -Body $query
                $response | Write-MIAResponse -Typename "MIATaskRunning" -IncludePaging:$IncludePaging
            }
            'List' {
                $query = @{}
                switch ($PSBoundParameters.Keys) {
                    Name { $query['name'] = $Name }
                    Fields { $query['fields'] = $Fields -join ',' }
                    Page { $query['page'] = $Page }
                    PerPage { $query['perPage'] = $PerPage }
                }
                $response = Invoke-RestMethod -Uri "$uri" -Headers $headers -Body $query
                $response | Write-MIAResponse -Typename "MIATask" -IncludePaging:$IncludePaging
            }
        }
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}