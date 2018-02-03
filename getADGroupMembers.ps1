# ------------------------------------------------------------------------
# NAME: getADGroupMembers.ps1
# AUTHOR: spatournos
# DATE:Jan 2018
#
# COMMENTS: This script takes a list of Active Directory User groups, 
# in the form of a txt file (each line must be a valid AD User Group), 
# lists their members (name,ID etc) and creates csv files, 
# named after the groups with the results.
#
# ------------------------------------------------------------------------

<#
.SYNOPSIS
  List users of given AD user groups
.DESCRIPTION
  Create csv files containing group members of AD groups (ID, name, Site etc)
.INPUTS
  ADgroups.txt
.OUTPUTS
  ADgroups.csv
.EXAMPLE
  getADGroupMembers.ps1
.LINK
  https://support.microsoft.com/en-us/help/2693643/remote-server-administration-tools-rsat-for-windows-operating-systems
 #>

# For starters check:
# https://support.microsoft.com/en-us/help/2693643/remote-server-administration-tools-rsat-for-windows-operating-systems
Import-Module ActiveDirectory 

$ADgroups=".\ADGroups.txt" 
foreach ($pvg in Get-Content $ADgroups)
{
  Get-ADGroupMember $pvg | Get-ADUser -Property displayName | 
  select @{name="AM";Expression={$_.samaccountname}},@{name="USER";Expression={$_.displayname}},
	@{name="Site";Expression={$_.DistinguishedName.split(',')[1].split('=')[1]}} | 
  Export-Csv -path .\"$pvg".csv -encoding "utf8" -NoTypeInformation
}
