function Wait-MIATask {
    <#
        .SYNOPSIS
        Wait for a MOVEit Automation Task to complete
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
            ValueFromPipelineByPropertyName)]
        [string]$TaskId,

        [Parameter(Mandatory,
            ValueFromPipelineByPropertyName)]
        [string]$NominalStart,

        [Parameter()]
        [int32]$Timeout = 60
    )

    try {
        # Poll the running tasks every 2 seconds
        $startTime = Get-Date
        $elapsed = 0

        do {
            Start-Sleep -Seconds 2
            $running = (Get-MIATask -Running | Where-Object {$_.TaskId -eq $TaskId -and $_.NominalStart -eq $NominalStart})        
            $elapsed = New-TimeSpan -Start $startTime
        } while ($running -and $elapsed.TotalSeconds -le $Timeout) 

        # Write out a custom object with the results
        [PSCustomObject]@{
            TaskId = $TaskId
            NominalStart = $NominalStart
            IsComplete = (-not $running)
            Status = if ($running) {$running.status}
            Elapsed = $elapsed
        }
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}