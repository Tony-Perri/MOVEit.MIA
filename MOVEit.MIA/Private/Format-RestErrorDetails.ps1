function Format-RestErrorDetails{
    [CmdletBinding()]
    param(
        [Parameter(Position=0)]
        [System.Management.Automation.ErrorRecord]
        $ErrorRecord
    )

    # Reformat ErrorDetails which contains the JSON response from the REST API    
    # try {
        # Check if there actually is a message
        if ($ErrorRecord.ErrorDetails.Message) {
            # ...and check if we think it is a message we can reformat
            if ($ErrorRecord.CategoryInfo.Reason -in 'HttpResponseException','WebException') {
                # ...should be good to go
                $restResponse = $ErrorRecord.ErrorDetails.Message | ConvertFrom-Json
                
                $message = 
                    if     ($restResponse.detail)            { $restResponse.detail }
                    elseif ($restResponse.error_description) { $restResponse.error_description}
                    elseif ($restResponse.error)             { $restResponse.error}
                    else                                     { 'Unspecified error. Check the $Error variable'}
                
                $ErrorRecord.ErrorDetails = [System.Management.Automation.ErrorDetails]::new(
                    ("{0} (Status Code: {1:d})" -f $message, $ErrorRecord.Exception.Response.StatusCode)
                )
            }
        }
    # }
    # catch {
        # Just eat whatever exception happened and return the original error record
    # }
    
    $ErrorRecord
}