# Add ToString() method to custom types
$typeName = @(
    'MIATask'
    'MIATaskDetail'
    'MIAHost'
    'MIAHostDetail'
    'MIACustomScript'
)

$typeName | ForEach-Object {
    Update-TypeData -TypeName $_ -MemberType 'ScriptMethod' -MemberName 'ToString' -Force -Value {
        "$($this.name) ($($this.Id))"
    }
}

# Add GetSteps() method to MIATask and MIATaskDetail to make it easier to work
# with the steps for a task
$typeName = @(
    'MIATask'
    'MIATaskDetail'
)

$typeName | ForEach-Object {
    Update-TypeData -TypeName $_ -MemberType 'ScriptMethod' -MemberName 'GetSteps' -Force -Value {
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
}