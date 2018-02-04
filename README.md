# Active Directory scripts in powershell
_________________________________________

# getADGroupMembers
Given a list of Active Directory User groups, in the form of a txt file
(each line must be a valid AD User Group), list their members (name,ID etc)
and create csv files, named after the groups with the results.

# disableADUser
Given a list of Active Directory Users, in the form of a csv file 
(each line must be a valid AD User), remove all memberships, disable account and move User to OU:Not_Active


