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

    begin {
        # Set the resourse for this request
        $resource = "tasks"
    }

    # Place in a process block so if nothing is passed in, like via pipeline, the function doesn't try
    # to execute using missing data.
    process {
        try {
            # Send the request and write the response
            switch ($PSCmdlet.ParameterSetName) {
                'Detail' {
                    Invoke-MIARequest -Resource "$resource/$TaskId" -Context $Context |
                        Write-MIAResponse -TypeName 'MIATaskDetail'
                }
                'Running' {
                    $query = @{}
                    switch ($PSBoundParameters.Keys) {
                        Name { $query['name'] = $Name }
                        Fields { $query['fields'] = $Fields -join ',' }
                        Page { $query['page'] = $Page }
                        PerPage { $query['perPage'] = $PerPage }
                    }
                    Invoke-MIARequest -Resource "$resource/running" -Body $query -Context $Context |
                        Write-MIAResponse -Typename "MIATaskRunning" -IncludePaging:$IncludePaging
                }
                'List' {
                    $query = @{}
                    switch ($PSBoundParameters.Keys) {
                        Name { $query['name'] = $Name }
                        Fields { $query['fields'] = $Fields -join ',' }
                        Page { $query['page'] = $Page }
                        PerPage { $query['perPage'] = $PerPage }
                    }
                    Invoke-MIARequest -Resource "$resource" -Body $query -Context $Context |
                        Write-MIAResponse -Typename "MIATask" -IncludePaging:$IncludePaging
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}