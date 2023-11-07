function Select-MiATaskStep {
    <#
        .SYNOPSIS
        Select type(s) of steps from anywhere in a task
        .NOTES
        Most useful for Advanced tasks where steps are nested
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [PSTypeName('MOVEit.MIA.Task')]
        [psobject]$Task,
        
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
        # Initialize the array with this object, but it will grow as nested objects are appended to the array
        $objArray = @($Task)

        for ($i = 0; $i -lt $objArray.Count; $i++) {
            $objArray[$i].PSObject.Properties | ForEach-Object {
                if ($_.Name -in $StepType) {
                    # This is a property we are looking for
                    [pscustomobject]@{$_.Name = $_.Value}                
                }
                
                if ($_.Name -in $containerName) {
                    # Append this object array to the end so these get processed too.
                    $objArray += @($_.Value)
                }
            }
        }
    }
}