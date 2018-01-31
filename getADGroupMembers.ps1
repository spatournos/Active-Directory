foreach ($pvg in Get-Content .\privategroups.txt){
Get-ADGroupMember $pvg | Get-ADUser -Property displayName | 
select @{name="AM";Expression={$_.samaccountname}},@{name="USER";Expression={$_.displayname}} | 
Export-Csv -path .\"$pvg".csv -encoding "utf8" -NoTypeInformation}
