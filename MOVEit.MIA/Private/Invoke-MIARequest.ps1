using namespace Microsoft.PowerShell.Commands
function Invoke-MIARequest {
    <#
    .SYNOPSIS
        Function all cmdlets call to send a request to MIA.
    .DESCRIPTION
        First confirms that the auth token hasn't expired.  Then sends the request
        and writes the response to the pipeline.
    #>    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                    Position=0)]
        [string]$Resource,
        
        [Parameter()]
        [WebRequestMethod]$Method = [WebRequestMethod]::Get,

        [Parameter()]
        [string]$Accept = 'application/json',

        [Parameter()]
        [string]$ContentType,

        [Parameter()]
        [System.Object]$Body,

        # Context
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Context
    )

    try {
        # Confirm the Token
        Confirm-MIAToken -Context $Context

        # Return the context which is a hashtable in the 
        # $script:Context hashtable.
        $ctx = $script:Context[$Context]
        
        # We'll use a splat so we can include just the parameters specified to call IRM.
        # We'll start with the defaults, then add anything that is passed in.
        $irmParams = @{
            Uri     = "$($ctx.BaseUri)/$Resource"
            Method  = $Method
            Headers = @{
                Accept        = "$Accept"
                Authorization = "Bearer $($ctx.Token.AccessToken)"
            }
            UserAgent = $script:USER_AGENT
        }

        # if ($Method -in ([WebRequestMethod]::Post, [WebRequestMethod]::Put, [WebRequestMethod]::Patch)) {
        #     if ($PSBoundParameters.ContainsKey('Body')) {
        #         # ToDo: Set the ContentType based on the Request Method and maybe do the
        #         # body | ConvertTo-Json here too?
        #     }
        # }

        # Add any add'l params that were passed in
        switch ($PSBoundParameters.Keys) {
            ContentType      { $irmParams['ContentType']      = $ContentType }
            Body             { $irmParams['Body']             = $Body }
        }

        Write-Verbose "Uri: $($irmParams.Uri)"
        Write-Verbose "Method: $($irmParams.Method)"
        Write-Verbose "Accept: $($irmParams.Headers.Accept)"
        Write-Verbose "ContentType: $($irmParams.ContentType)"        

        # Send the request and write out the response
        Invoke-RestMethod @irmParams
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}