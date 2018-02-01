# As input use a .csv file named with format: 
#  user,
#  "UserID"
#The user name will be referenced as $_.User in powershell 
$csvFile = ".\hello.csv"
# Create a log file
$log = ".\kitty.log"
# Set OU for "Not Active users"
$disabledUsersOU = "OU=_Not Active Users,DC=my,DC=domain,DC=com"

Import-Csv $csvFile | ForEach-Object 
{
  # Retrieve the user object and MemberOf property
  $user = Get-ADUser -Identity $_.User -Properties MemberOf
	
  # Remove all group memberships (will leave Domain Users as this is NOT in the MemberOf property returned by Get-ADUser)
  foreach ($group in ($user | Select-Object -ExpandProperty MemberOf))
  {
    # -Confirm:$false DON'T CONFIRM THE GROUPS TO REMOVE
    # Remove the flag if you want confirmation
    Remove-ADGroupMember -Identity $group -Members $user -Confirm:$false
  }
	
  # Disable the account
  Disable-ADAccount -Identity $_.User
		
  # Move user object to disabled users OU
  $user | Move-ADObject -TargetPath $disabledUsersOU
	
  # Print info in screen and in log file
  Write-Host "Moved user: "$_.User"to Not Active Users"
  Write-Output "Moved user: $($_.User) to Not Active Users" | Out-File $log -append
}

