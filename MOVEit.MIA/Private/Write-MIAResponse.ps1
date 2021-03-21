function Write-MIAResponse {    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,
                    ValueFromPipeline=$true)]
        [PSObject]$Response,
        
        [Parameter(Mandatory=$false)]
        [string]$TypeName,

        [Parameter(Mandatory=$false)]
        [switch]$IncludePaging
    )

    # Write out paging info to console if in verbose mode
    if ($Response.paging) {
        Write-Verbose ("totalItems: {0} perPage: {1}  page: {2} totalPages: {3}" -f
                $response.paging.totalItems, $response.paging.perPage, 
                $response.paging.page, $response.paging.totalPages)
    }

    # Add type and write the paging info.  Want to send this down the pipeline first
    # so the caller can check the first item for this information if they want
    # to loop through multiple pages, etc.
    if ($Response.paging -and $IncludePaging) {
        $Response.paging.PSObject.TypeNames.Insert(0,'MIAPaging')
        $Response.paging 
    }

    # Add type to the items for better display from .format.ps1xml file and write
    # to the pipeline
    if ($Response.psobject.properties['items']) {
        if ($TypeName) {
            $Response.items | foreach-object { $_.PSOBject.TypeNames.Insert(0,$TypeName) }
        }
        $Response.items
    }
    else {
        if ($TypeName) {
            $Response.PSOBject.TypeNames.Insert(0,$TypeName)
        }
        $Response
    }   
}