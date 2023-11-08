function Get-MIATaskLog {
    <#
        .SYNOPSIS
        Get MOVEit Automation Task Log(s)
    #>
    [CmdletBinding(DefaultParameterSetName='List')]
    [OutputType('MOVEit.MIA.TaskLog', ParameterSetName='List')]
    [OutputType([string], ParameterSetName='Detail')]
    param (
        [Parameter(Mandatory,
                    ValueFromPipelineByPropertyName,
                    ParameterSetName='List')]
        [Parameter(Mandatory,
                    ParameterSetName='Detail')]
        [Alias('Id')]                    
        [string]$TaskId,

        [Parameter(Mandatory,
                    ValueFromPipelineByPropertyName,
                    ParameterSetName='Detail')]
        [string]$TaskLogId,

        [Parameter(ParameterSetName='List')]
        [ValidateSet('id','taskId','startTime','exitStatus', IgnoreCase = $false)]                    
        [string[]]$Fields,

        [Parameter(ParameterSetName='List')]
        [int32]$Page,

        [Parameter(ParameterSetName='List')]
        [int32]$PerPage,
        
        [Parameter(ParameterSetName='List')]   
        [switch]$IncludePaging,

        # Context
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$Context = $script:DEFAULT_CONTEXT
    )

    process {
        # Set the resource for this request        
        $resource = "tasks/$TaskId/log"

        try {   
            # Send the request and write the response
            switch ($PSCmdlet.ParameterSetName) {
                'Detail' {
                    # This request is for text/plain
                    Invoke-MIARequest -Resource "$resource/$TaskLogId" -Accept 'text/plain' -Context $Context
                }
                'List' {
                    $query = @{}
                    switch ($PSBoundParameters.Keys) {
                        Fields  { $query['fields']  = $Fields -join ','}
                        Page    { $query['page']    = $Page }
                        PerPage { $query['perPage'] = $PerPage }
                    }
                    Invoke-MIARequest -Resource "$resource" -Body $query -Context $Context |
                        Write-MIAResponse -Typename 'MOVEit.MIA.TaskLog' -IncludePaging:$IncludePaging
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}