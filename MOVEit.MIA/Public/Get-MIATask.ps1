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
        [string]$Fields,

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
        [switch]$IncludePaging
    )

    try {   
        # Confirm the Token, refreshing if necessary
        Confirm-MIAToken
         
        # Set the Uri for this request
        $uri = "$script:BaseUri/tasks"
                    
        # Set the request headers
        $headers = @{
            Accept = "application/json"
            Authorization = "Bearer $($script:Token.AccessToken)"
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
                    Fields { $query['fields'] = $Fields }
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
                    Fields { $query['fields'] = $Fields }
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