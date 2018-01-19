# Lines 2-8 Check whether the terminal is running with Admin privaledge, if not it opens an Admin terminal and imports all code below to the Admin terminal.
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))

{   
$arguments = "& '" + $myinvocation.mycommand.definition + "'"
Start-Process powershell -Verb runAs -ArgumentList $arguments
Break
}

echo "Allow or Block a port?"
$Protection = read-host

echo "Enter port number to $Protection "
$Port = read-host

echo "Enter Protocol (tcp or udp)"
$Protocol = read-host

echo "Inbound or Outbound?"
$Direction = read-host

echo "Enter IP address, range (ex. 192.168.1.10 through 192.168.1.50) or subnet (ex. 192.168.1.0/24). Type any for all IP addresses."
$IPAddress = read-host

New-NetFirewallRule -DisplayName "$Protection Port $Port - $Protocol - $Direction - $IPAddress" -Action $Protection -Direction $Direction -LocalPort $Port -Protocol $Protocol -RemoteAddress $IPAddress

read-host "Press any key to quit..."