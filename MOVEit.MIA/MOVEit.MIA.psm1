$PublicFunctions = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue)
$PrivateFunctions = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue)

# Dot source the files
Foreach($file in @($PublicFunctions + $PrivateFunctions)) {
    Try {
        . $file.FullName
    }
    Catch {
        Write-Error -Message "Failed to import $($file.FullName): $_"
    }
}

# Create any Aliases
Set-Alias -Name Get-MIATaskRun -Value Get-MIAReportTaskRun
Set-Alias -Name Get-MIAFileActivity -Value Get-MIAReportFileActivity
Set-Alias -Name Get-MIAAudit -Value Get-MIAReportAudit

Export-ModuleMember -Function $PublicFunctions.Basename -Alias 'Get-MIA*'

# Update the format data to display the Log output and paging info   
Update-FormatData -AppendPath "$PSScriptRoot\Format\MIA.Format.ps1xml" 
Update-FormatData -AppendPath "$PSScriptRoot\Format\MIALog.Format.ps1xml"