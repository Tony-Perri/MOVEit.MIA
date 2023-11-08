function Select-MIATaskStep {
    <#
        .SYNOPSIS
        Select type(s) of steps from anywhere in a task
        .NOTES
        Most useful for Advanced tasks where steps are nested
        .EXAMPLE
        $task | Select-MIATaskStep
        .EXAMPLE
        $task | Select-MIATaskStep -StepType Process -Expand
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [PSTypeName('MOVEit.MIA.Task')]
        [psobject]$Task,
        
        [Parameter()]
        [ValidateSet('Source', 'Process', 'Destination', 'NextAction', 
                     'Email', 'Comment', 'For', 'If', 'RunTask', 'UpdOrig')]
        [string[]]$StepType = @('Source', 'Process', 'Destination', 'NextAction', 'Email', 'RunTask'),

        [Parameter()]
        [switch]$Expand
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
                    if ($Expand) {
                        # ... add a member for the step type and return the expanded object
                        $_.Value | Add-Member -MemberType NoteProperty -Name 'StepType' -Value $_.Name -Force
                        $_.Value
                    } else {
                        # ... return an object where the property is the steptype
                        [pscustomobject]@{$_.Name = $_.Value}
                    }
                }
                
                if ($_.Name -in $containerName) {
                    # Append this object array to the end so these get processed too.
                    $objArray += @($_.Value)
                }
            }
        }
    }
}