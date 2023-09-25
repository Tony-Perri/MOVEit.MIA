function Connect-MIAServer {
    <#
    .SYNOPSIS
        Connect to a MOVEit Automation server and create an auth token.
    .DESCRIPTION
        Create an auth token using the /api/v1/token endpoint.
        Call before calling any other Get-MIA* commands.            
    .EXAMPLE
        Connect-MIAServer
        User is prompted for parameters.
    .EXAMPLE
        Connect-MIAServer -Hostname 'moveitauto.server.com' -Credential (Get-Credential -Username 'admin')
        Supply parameters on command line except for password.
    .INPUTS
        None.
    .OUTPUTS
        String message if connected.
    .LINK
        See link for /api/v1/token doc.
        https://docs.ipswitch.com/MOVEit/Automation2020/API/REST-API/index.html#_authrequestauthtokenusingpost
    #>
    [CmdletBinding()]
    param (      
        # Hostname for the endpoint                 
        [Parameter(Mandatory=$true)]
        [string]$Hostname,
        
        # Credentials
        [Parameter(Mandatory=$true)]
        [pscredential]$Credential,

        # ServerHost
        [Parameter(Mandatory=$false)]
        [string]$ServerHost,
        
        # Context
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$Context = $script:DEFAULT_CONTEXT
    )     
    
    try {   
        # Initialize the context
        $ctx = @{
            Token = @()
            BaseUri = "https://$Hostname/api/v1"
        }
        
        # Build the request
        $uri = "$($ctx.BaseUri)/token"
        $params = @{ 
            Method = 'POST'
            ContentType = 'application/x-www-form-urlencoded'        
            Headers = @{Accept = "application/json"} 
            UserAgent = 'MOVEit REST API'           
        }
        
        # Build the request body
        $body = @{
            grant_type = 'password'
            username = $Credential.UserName
            password= $Credential.GetNetworkCredential().Password
        }

        if ($PSBoundParameters.ContainsKey('ServerHost')) {
            $body['server_host'] = $ServerHost
        }

        $response = Invoke-RestMethod -Uri $uri -Body $body @params

        if ($response.access_token) {
            $ctx.Token = @{                    
                AccessToken = $Response.access_token
                CreatedAt = $(Get-Date)
                ExpiresIn = $Response.expires_in
                RefreshToken = $Response.refresh_token
            }

            # Update the script variable with the new context
            $script:Context[$Context] = $ctx

            Write-Output "[$Context]: Connected to MOVEit Automation server $Hostname"
        }
    } 
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }   
}