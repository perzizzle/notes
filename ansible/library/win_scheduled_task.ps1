#!powershell
# This file is part of Ansible
#
# Copyright 2015, Peter Mounce <public@neverrunwithscissors.com>
# Michael Perzel <michaelperzel@gmail.com>
#
# Ansible is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ansible is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ansible.  If not, see <http://www.gnu.org/licenses/>.

$ErrorActionPreference = "Stop"

# WANT_JSON
# POWERSHELL_COMMON

$params = Parse-Args $args;

$days_of_week = Get-Attr $params "days_of_week" $null;
$minute = Get-Attr $params "minute" $null;
$enabled = Get-Attr $params "enabled" $true | ConvertTo-Bool;
$description = Get-Attr $params "description" " ";
$path = Get-Attr $params "path" "\";
$argument = Get-Attr $params "argument" $null;
$working_directory = Get-Attr $params "working_directory" $null;

$result = New-Object PSObject;
Set-Attr $result "changed" $false;

#Required vars
$name = Get-Attr -obj $params -name name -failifempty $true -resultobj $result
$state = Get-Attr -obj $params -name state -failifempty $true -resultobj $result
if( ($state -ne "present") -and ($state -ne "absent") ) {
    Fail-Json $result "state must be present or absent"
}

#Vars conditionally required
if($state -eq "present") {
    $execute = Get-Attr -obj $params -name execute -failifempty $true -resultobj $result
    $frequency = Get-Attr -obj $params -name frequency -failifempty $true -resultobj $result
    $time = Get-Attr -obj $params -name time -failifempty $true -resultobj $result
    $user = Get-Attr -obj $params -name user -failifempty $true -resultobj $result
}

if ($frequency -eq "minutely")
{
    if (!($minute))
    {
        Fail-Json $result "missing required argument: minute"
    }
}
elseif ($frequency -eq "weekly")
{
    if (!($days_of_week))
    {
        Fail-Json $result "missing required argument: days_of_week"
    }
}

#backwards compatibility massaging
if ($working_directory -eq ""){
    $working_directory = $null
}

if($path -ne "\") {
    $path = "\{0}\" -f $path
}

try {
    $task = Get-ScheduledTask -TaskPath "$path" | Where-Object {$_.TaskName -eq "$name"}

    # Correlate task state to enable variable, used to calculate if state needs to be changed
    $taskState = Get-Attr $task "State" $null;
    if ($taskState -eq "Ready"){
        $taskState = $true
    }
    elseif($taskState -eq "Disabled"){
        $taskState = $false
    }
    else
    {
        $taskState = $null
    }

    $measure = $task | measure
    if ($measure.count -eq 1 ) {
        $exists = $true
    }
    elseif ( ($measure.count -eq 0) -and ($state -eq "absent") ){
        Set-Attr $result "msg" "Task does not exist"
        Exit-Json $result
    }
    elseif ($measure.count -eq 0){
        $exists = $false
    }
    else {
        # This should never occur
        Fail-Json $result "$($measure.count) scheduled tasks found"
    }

    Set-Attr $result "exists" "$exists"

    if ($frequency){
        if ( $frequency -eq "minutely"){
            $trigger = New-ScheduledTaskTrigger -Once -RepetitionInterval (new-timespan -minute $minute) -At $time -RepetitionDuration ([timespan]::MaxValue)
        }
        elseif ( $frequency -eq "hourly"){
            $trigger = New-ScheduledTaskTrigger -Once -RepetitionInterval (new-timespan -hour 1) -At $time -RepetitionDuration ([timespan]::MaxValue)
        }
        elseif ($frequency -eq "daily") {
            $trigger =  New-ScheduledTaskTrigger -Daily -At $time
        }
        elseif ($frequency -eq "weekly"){
            $trigger =  New-ScheduledTaskTrigger -Weekly -At $time -DaysOfWeek $days_of_week
        }
        elseif ($frequency -eq "once"){
            $trigger =  New-ScheduledTaskTrigger -Once -At $time
        }
        else {
            Fail-Json $result "frequency must be minutely, hourly, daily or weekly"
        }
    }

    if ( ($state -eq "absent") -and ($exists -eq $true) ) {
        Unregister-ScheduledTask -TaskName $name -Confirm:$false
        $result.changed = $true
        Set-Attr $result "msg" "Deleted task $name"
        Exit-Json $result
    }
    elseif ( ($state -eq "absent") -and ($exists -eq $false) ) {
        Set-Attr $result "msg" "Task $name does not exist"
        Exit-Json $result
    }

    $principal = New-ScheduledTaskPrincipal -UserId "$user" -LogonType ServiceAccount -RunLevel Highest

    if ($enabled -eq $false){
        $settings = New-ScheduledTaskSettingsSet -Disable
    }
    else {
        $settings = New-ScheduledTaskSettingsSet
    }
    
    if ($argument -eq $null -and $working_directory -eq $null) {
	   $action = New-ScheduledTaskAction -Execute $execute
    }
    elseif ($argument -ne $null -and $working_directory -eq $null) {
	   $action = New-ScheduledTaskAction -Execute $execute -Argument $argument
    }
    elseif ($argument -eq $null -and $working_directory -ne $null) {
	   $action = New-ScheduledTaskAction -Execute $execute -WorkingDirectory $working_directory
    }
    else {
	   $action = New-ScheduledTaskAction -Execute $execute -Argument $argument -WorkingDirectory $working_directory
    }

    if ( ($state -eq "present") -and ($exists -eq $false) ){
        Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $name -Description $description -TaskPath $path -Settings $settings -Principal $principal
        $task = Get-ScheduledTask -TaskName $name
        Set-Attr $result "msg" "Added new task $name"
        $result.changed = $true
    }
        #if ($task.Description -eq $description -and $task.TaskName -eq $name -and $task.TaskPath -eq $path -and $task.Actions.Execute -eq $execute -and $taskState -eq $enabled -and $task.Principal.UserId -eq $user) {
        if($false) {
            #No change in the task yet
    elseif( ($state -eq "present") -and ($exists -eq $true) ) {
            Set-Attr $result "msg" "No change in task $name"
        }
        else {
            Unregister-ScheduledTask -TaskName $name -Confirm:$false
            Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $name -Description $description -TaskPath $path -Settings $settings -Principal $principal
            Set-Attr $result "msg" "Updated task $name"
            $result.changed = $true
        }
    }

    Exit-Json $result;
}
catch
{
  Fail-Json $result $_.Exception.Message
}
