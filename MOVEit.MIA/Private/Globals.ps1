# BaseUri for the MOVEit Automation server
# Will be set by Connect-MIAServer
# $script:BaseUri = '' # deprecated

# Variable to hold the current Auth Token.
# Will be set by Connect-MIAServer
# $script:Token = @() # deprecated

# Support multiple contexts using the 
# -Context parameter.  We'll use a 
# hashtable to store each context.
$script:Context = @{
    Default = @{
        BaseUri = ''
        Token = @()
        SkipCertificateCheck = $false
    }
}

$script:DEFAULT_CONTEXT = 'Default'

$script:USER_AGENT = 'MOVEit.MIA'