function Get-MIAHost {
    <#
        .SYNOPSIS
        Get a MOVEit Automation Host(s)
    #>
    [CmdletBinding(DefaultParameterSetName='List')]
    param (
        [Parameter(Mandatory,
                    Position = 0,
                    ValueFromPipelineByPropertyName=$true,
                    ParameterSetName='Detail')]
        [Alias('Id')]
        [string]$HostId,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [string]$Name,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [ValidateSet('FileSystem', 'FTP', 'POP3', 'Share',
                        'siLock', 'SMTP', 'SSHFTP', 'AS1', 'AS2', 'AS3','S3',
                        'SharePoint', 'AzureBlob', IgnoreCase = $false)]
        [string]$Type,

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

    try {
        # Confirm the Token, refreshing if necessary
        Confirm-MIAToken

        # Set the Uri for this request
        $uri = "$script:BaseUri/hosts"
                    
        # Set the request headers
        $headers = @{
            Accept = "application/json"
            Authorization = "Bearer $($script:Token.AccessToken)"
        }    

        # Send the request and write the response
        switch ($PSCmdlet.ParameterSetName) {
            'Detail' {
                $response = Invoke-RestMethod -Uri "$uri/$HostId" -Headers $headers
                $response | Write-MIAResponse -TypeName 'MIAHostDetail'
            }
            'List' {
                $query = @{}
                switch ($PSBoundParameters.Keys) {
                    Name { $query['name'] = $Name }
                    Type { $query['type'] = $Type }
                    Fields { $query['fields'] = $Fields }
                    Page { $query['page'] = $Page }
                    PerPage { $query['perPage'] = $PerPage }
                }
                $response = Invoke-RestMethod -Uri "$uri" -Headers $headers -Body $query                
                
                # The JSON returned is a bit unique when parsed into a PSObject
                # in that the "Type" becomes a property and then the actual object
                # is nested under that, so we'll modify the $response.items so that
                # it directly contains the host members, similar to all other
                # responses.

                # A list of the possible host types to make sure we access the
                # correct properties
                $hostTypes = @('FileSystem', 'FTP', 'POP3', 'Share',
                    'siLock', 'SMTP', 'SSHFTP', 'AS1', 'AS2', 'AS3','S3',
                    'SharePoint', 'AzureBlob')

                # Doing this as an array so we can directly modify the items array
                for($i=0; $i -lt $response.items.count; $i++) {
                    # Iterate over each property to find the one that
                    # is one of our host types.  Seems like this only returns
                    # the one NoteProperty, but still doing it this way to be
                    # safe.
                    foreach($prop in $response.items[$i].PSObject.Properties) {
                        $propName = $prop.Name
                        # Let's see if this is the property whose value we want and, if so, ...
                        if ($propName -in $hostTypes) {
                            $hostObj = $response.items[$i].$propName
                            #Add the name as a Type property to the host object
                            Add-Member -InputObject $hostObj -MemberType NoteProperty -Name Type -Value $propName
                            # Set the items element in the array directly to the hostObj
                            $response.items[$i] = $hostObj
                        }
                    }
                }

                $response | Write-MIAResponse -Typename "MIAHost" -IncludePaging:$IncludePaging
            }
        }
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}