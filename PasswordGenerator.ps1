# ------------------------------------------------------------------------
# NAME: PasswordGenerator.ps1
# AUTHOR: spatournos
# DATE: Feb 2026
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
 
#Create Strong Password
[array]$symbols=@('+','-','*','/','?','\','#','@','$','%','_')
$passLength=14
$randomstring=for ($i=0;$i -lt $passLength;$i++) {
    $choice=$(get-random -min 0 -max 99) % 4
    switch ($choice)
    {
        0 {[char]$(Get-Random -Min 65 -Max 90)}
        1 {[char]$(Get-Random -Min 97 -Max 122)}
        2 {$symbols[$(Get-Random -Min 0 -Max $($symbols.count-1))]}
        3 {$(Get-Random -Min 0 -Max 9)}
    }
}
$randomstring=$randomstring -join ""
Write-Output "New password: $randomstring"

#Check Password Strength
$score = 0
if ($randomstring.Length -lt 5) {
Write-Verbose '$randomstring length is less than 5 characters.'
Write-Output 'Very Weak'
break
}
if ($randomstring.Length -ge 8) {
Write-Verbose '$randomstring length is equal to or greater than 8 characters. Added 1 to $randomstring score.'
$score++
}
if ($randomstring.Length -ge 12) {
Write-Verbose '$randomstring length is equal to or greater than 12 characters. Added 1 to $randomstring score.'
$score++
}
if ([regex]::IsMatch($randomstring, '\d+')) {
Write-Verbose '$randomstring contains numbers. Added 1 to $randomstring score.'
$score++
}
if ([regex]::IsMatch($randomstring, '[a-z]+')) {
Write-Verbose '$randomstring lowercase letters. Added 1 to $randomstring score.'
$score++
}
if ([regex]::IsMatch($randomstring, '[A-Z]+')) {
Write-Verbose '$randomstring uppercase letters. Added 1 to $randomstring score.'
$score++
}
if ([regex]::IsMatch($randomstring, '[!@#$%^&*?_~-£(){},]+')) {
Write-Verbose '$randomstring symbols. Added 1 to $randomstring score.'
$score++
}
switch ($score) {
1 { $randomstringScore = 'Very Weak' }
2 { $randomstringScore = 'Weak' }
3 { $randomstringScore = 'Medium' }
4 { $randomstringScore = 'Strong' }
5 { $randomstringScore = 'Strong' }
6 { $randomstringScore = 'Very Strong' }
}
Write-Output "Password Strength: $randomstringScore"

