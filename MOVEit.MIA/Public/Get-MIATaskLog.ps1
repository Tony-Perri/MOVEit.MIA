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
        [string]$Fields,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [int32]$Page,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [int32]$PerPage,
        
        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]   
        [switch]$IncludePaging
    )

        # Check to see if Connect-MIAServer has been called and exit with an error
    # if it hasn't.
    if (-not $script:BaseUri) {
        Write-Error "BaseUri is invalid.  Try calling Connect-MIAServer first."
        return        
    }

    # Set the Uri for this request
    $uri = "$script:BaseUri/tasks/$TaskId/log"
                
    # Set the request headers
    $headers = @{
        Accept = "application/json"
        Authorization = "Bearer $($script:Token.AccessToken)"
    }    

    # Send the request and write the response
    try {   
        # Confirm the Token, refreshing if necessary
        Confirm-MIAToken
         
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
                    Fields { $query['fields'] = $Fields }
                    Page { $query['page'] = $Page }
                    PerPage { $query['perPage'] = $PerPage }
                }
                $response = Invoke-RestMethod -Uri "$uri" -Headers $headers -Body $query 
                $response | Write-MIAResponse -Typename "MIATaskLog" -IncludePaging:$IncludePaging
            }
        }
    }
    catch {
        $_
    }
}