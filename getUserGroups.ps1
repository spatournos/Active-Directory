# ------------------------------------------------------------------------
# NAME: getADUserGroups.ps1
# AUTHOR: spatournos
# DATE: Jul 2018
#
# COMMENTS: This script takes a list of Active Directory Users, 
# in the form of a txt file (each line must be a valid AD UserID), 
# lists their AD Groups members by name and creates txt files, 
# named after the userID with the results.
#
# ------------------------------------------------------------------------

<#
.SYNOPSIS
  List groups of given AD user 
.DESCRIPTION
  Create txt files containing AD groups by name
.INPUTS
  gets.txt
.OUTPUTS
  UserID.txt
.EXAMPLE
  getUserGroups.ps1
.LINK
  https://community.spiceworks.com/topic/1961783-import-a-list-of-users-to-get-what-groups-they-belong-to
 #>

# For starters check:
# https://support.microsoft.com/en-us/help/2693643/remote-server-administration-tools-rsat-for-windows-operating-systems
Try
{
  Import-Module ActiveDirectory -ErrorAction Stop
}
Catch
{
  Write-Host "[ERROR]`t ActiveDirectory Module couldn't be loaded. Script will stop!"
  Exit 1
}

$gets=".\gets.txt"
$gotUsers= Get-Content $gets
foreach ($UserName in $gotUsers)
{
    If ($UserName) 
    { 
        $UserName = $UserName.ToUpper().Trim() 
        $Res = (Get-ADPrincipalGroupMembership $UserName | Measure-Object).Count 
        If ($Res -GT 0) 
        { 
            Write-Output "`n" 
            Write-Output "User $UserName is a Member Of the Following Groups:" 
            Write-Output "=================================================" 
            Get-ADPrincipalGroupMembership $UserName | Select Name | Sort Name | FT -A
            Get-ADPrincipalGroupMembership $UserName | Select Name | Sort Name | FT -A | Out-File .\"$UserName".txt 
        
        }
    }
}

Write-Host "Listed groups for" $gotUsers.count "users" 
