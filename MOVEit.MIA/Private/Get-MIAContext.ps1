function Get-MIAContext {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Context
    )

    # Return the context which is a hashtable in the 
    # $script:Context hashtable.
    $script:Context[$Context]
}