# Add ToString() method to custom types
$typeName = @(
    'MOVEit.MIA.CustomScript'
    'MOVEit.MIA.DateList'
    'MOVEit.MIA.GlobalParameter'
    'MOVEit.MIA.Host'
    'MOVEit.MIA.ResourceGroup'
    'MOVEit.MIA.SshKey'
    'MOVEit.MIA.StandardScript'
    'MOVEit.MIA.Task'
)

$typeName | ForEach-Object {
    Update-TypeData -TypeName $_ -MemberType 'ScriptMethod' -MemberName 'ToString' -Force -Value {
        if ($this.PSObject.properties.name -contains 'Id') {
            "$($this.name) ($($this.Id))"
        }
        else {
            "$($this.name)"
        }
    }
}

Update-TypeData -TypeName 'MOVEit.MIA.PgpKey' -MemberType 'ScriptMethod' -MemberName 'ToString' -Force -Value {
    "$($this.Uid) ($($this.Id))"
}

Update-TypeData -TypeName 'MOVEit.MIA.SslCert' -MemberType 'ScriptMethod' -MemberName 'ToString' -Force -Value {
    "$($this.IssuedTo) ($($this.SerialNum))"
}

# Add GetSteps() method to MOVEit.MIA.Task to make it easier to work
# with the steps for a task
Update-TypeData -TypeName 'MOVEit.MIA.Task' -MemberType 'ScriptMethod' -MemberName 'GetSteps' -Force -Value {
    # Iterate over each step in this object and return an array that makes it easier
    # to work with the steps in the object.
    $this.steps | ForEach-Object {
        # Iterate over each property where the property name is Source, Process or Destination.  Add
        # that as a property of the step object, and then return the actual step object.
        $_.PSOBject.properties | Where-Object { $_.Name -in 'Source', 'Process', 'Destination' } | ForEach-Object {
            Add-Member -InputObject $_.Value -MemberType 'NoteProperty' -Name 'StepType' -Value $_.name
            $_.value
        }
    }  
}
