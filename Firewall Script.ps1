# Lines 2-8 Check whether the terminal is running with Admin privaledge, if not it opens an Admin terminal and imports all code below to the Admin terminal.
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))

{   
$arguments = "& '" + $myinvocation.mycommand.definition + "'"
Start-Process powershell -Verb runAs -ArgumentList $arguments
Break
}

[int]$temp = 0
While ($temp -ne 9) {

echo "1 - Create New Firewall Rule"
echo "2 - Remove a Firewall Rule"
echo "3 - Enable a Firewall Rule"
echo "4 - Disable a Firewall Rule"
echo "5 - Change a Firewall Rule"
echo "9 - Exit"

$switch = read-host

Switch ($switch) {

	1 {
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
		
		Break

	}
	2 {
	Get-NetFirewallRule | Findstr DisplayName
	echo "Enter the display name of the rule you would like to remove"
	$rule = read-host
	Remove-NetFirewallRule -DisplayName $rule
	Break
	}	
	3 {
	Get-NetFirewallRule | Findstr "DisplayName Enabled"
	echo "Enter the display name of the rule you would like to enable"
	$rule = read-host
	Enable-NetFirewallRule -DisplayName $rule
	Break
	}
	4 {
	Get-NetFirewallRule | Findstr "DisplayName Enabled"
	echo "Enter the display name of the rule you would like to disable"
	$rule = read-host
	Disable-NetFirewallRule -DisplayName $rule
	Break
	}
	5 {
	Get-NetFirewallRule | Findstr "DisplayName"
	echo "Enter the rule you would like to change"
	$rule = read-host
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
		
		echo "Would you like to rename the firewall rule? (y or n)"
		$rename = read-host
		if ($rename -eq "y") {
			echo "would you like to rename the rule to {$Protection Port $Port - $Protocol - $Direction - $IPAddress}? (y or n)"
			$defaultrename = read-host
			if ($defaultrename -eq "y") {
				Set-NetFirewallRule -DisplayName $rule -NewDisplayName "$Protection Port $Port - $Protocol - $Direction - $IPAddress"  -Action $Protection -Direction $Direction -LocalPort $Port -Protocol $Protocol -RemoteAddress $IPAddress
			}
			elseif ($defaultrename -eq "n") {
				echo "Enter the new name for the firewall rule"
				$NewName = read-host
				Set-NetFirewallRule -DisplayName $rule -NewDisplayName $NewName
			}
			else {
				echo "Invalid input"
			}
		}
		elseif ($rename -eq "n") {
			Set-NetFirewallRule -DisplayName $rule -Action $Protection -Direction $Direction -LocalPort $Port -Protocol $Protocol -RemoteAddress $IPAddress
		}
		else {
			echo "Invalid input"
		}
	Break
	}
	9 { 
	$temp = 9 
	}
	default { 
	echo "Invalid input" 
	}
}
pause
cls
}
