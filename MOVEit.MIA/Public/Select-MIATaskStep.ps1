function Select-MiATaskStep {
    <#
        .SYNOPSIS
        Select type(s) of steps from anywhere in a task
        .NOTES
        Recursive
        Most useful for Advanced tasks where steps are nested
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [psobject]$InputObject,
        
        [Parameter()]
        [ValidateSet('Source', 'Process', 'Destination', 'NextAction', 
                     'Email', 'Comment', 'For', 'If', 'RunTask', 'UpdOrig')]
        [string[]]$StepType = @('Source', 'Process', 'Destination', 'NextAction', 'Email', 'RunTask')
    )

    begin { 
        # StepTypes that contain other stepTypes and should be recursed.       
        $containerName = 'steps', 'For', 'If', 'When', 'Otherwise', 'NextActions'
    }

    process {        
        $InputObject.PSObject.Properties | ForEach-Object {
            if ($_.Name -in $StepType) {
                # This is a property we are looking for
                [pscustomobject]@{$_.Name = $_.Value}                
            }
            
            if ($_.Name -in $containerName) {
                # Recurse
                $_.Value | Select-MiATaskStep -StepType $StepType
            }
        }
    }
}