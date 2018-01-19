# Lines 2-8 Check whether the terminal is running with Admin privaledge, if not it opens an Admin terminal and imports all code below to the Admin terminal.
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))

{   
$arguments = "& '" + $myinvocation.mycommand.definition + "'"
Start-Process powershell -Verb runAs -ArgumentList $arguments
Break
}

$MakeUser = "yes"

While ($MakeUser -eq "yes") {

echo "Is this a domain user account? (yes or no)"
$Domain = read-host

if ($Domain -eq "yes") {
	echo "Add or Remove user account?"
	$Function = read-host

	if ($Function -eq "remove") {
    		echo "Enter username to remove"
    		$user = read-host
    		net user $user /DELETE /DOMAIN}
	elseif ($Function -eq "add") {
    		echo "Enter username to add"
    		$user = read-host
    		net user $user * /ADD /DOMAIN}
	else
    		{echo "Error"}
	}
elseif ($Domain -eq "no") {
	echo "Add or Remove user account?"
	$Function = read-host

	if ($Function -eq "remove") {
    		echo "Enter username to remove"
    		$user = read-host
    		net user $user /DELETE }
	elseif ($Function -eq "add") {
    		echo "Enter username to add"
    		$user = read-host
    		net user $user * /add}
	else
    		{echo "Error"}
	}
else
	{echo "Error"}

echo "Would you like to add or remove another user? (yes or no)"
$MakeUser = read-host
}
