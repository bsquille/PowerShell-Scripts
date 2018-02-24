If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
$arguments = "& '" + $myinvocation.mycommand.definition + "'"
Start-Process powershell -Verb runAs -ArgumentList $arguments
Break
}

echo "Is DHCP Installed? (yes or no)"
$installed = read-host

if ($installed -eq "no") {
	Add-WindowsFeature -IncludeManagementTools dhcp }

elseif ($installed -eq "yes") {
	
	[int]$loop = 0
	While ($loop -ne 9) {
	
	echo "1 - Make this server a DHCP server"
	echo "2 - New the IPv4 scope"
	echo "3 - Remove an IPv4 scope"
	echo "4 - Set the DNS server"
	echo "5 - Set the Default Gateway"
	echo "6 - Create a Reservation"
	echo "7 - Remove a Reservation"
	echo "8 - Remove a DHCP server in the Domain"
	echo "9 - exit"
	
	[int]$temp = read-host

	Switch ($temp) {
		1 { 
			get-netipaddress | FindStr "IPAddress InterfaceAlias"
			echo "`nWhich Interface Alias will be used? (ex. Ethernet0)"
			$alias = read-host
			Get-ADDomain | FindStr /b Forest
			$hostname = hostname
			echo "hostname = $hostname"
			ipconfig | FindStr IPv4
			echo "`nEnter the DNS name (hostname.forest.com)"
			$DNS = read-host
			echo "Enter your IP address which is displayed above"
			$ip = read-host
			Set-DhcpServerv4Binding -BindingState $true -InterfaceAlias $alias
			Add-DhcpServerinDC -DnsName $DNS -IPAddress $ip
			Get-dhcpServerinDC
			Break
		}
		2 {
			echo "Name the scope"
			$name = read-host
			echo "Enter the start the the range (ex. 192.168.1.1)"
			$start = read-host
			echo "Enter the end of the range"
			$end = read-host
			echo "Enter the subnet mask"
			$mask = read-host
			echo "Enter the description of the scope"
			$desciption = read-host
			Add-dhcpServerv4Scope -Name $name -StartRange $start -EndRange $end -SubnetMask $mask -Description $description
			Get-DHCPServerv4Scope
			Break
		}
		3 {
			Get-DHCPServerv4Scope
			echo "`nEnter the scope ID of the scope being removed"
			$id = read-host
			remove-dhcpServerv4Scope -ScopeID $id
			echo ""
			Get-DHCPServerv4Scope
			Break
		}
		4 {
			echo "Enter the IP Address of the DNS server"
			$DNS = read-host
			Set-DhcpServerv4OptionValue -DnsServer $DNS -force
			Break
		}
		5 {
			echo "Enter the IP Address of the default gateway"
			$gateway = read-host
			Set-DhcpServerv4OptionDefinition -Option 6 -DefaultValue $gateway
			Break
		}
		6 {
			Get-DhcpServerv4Scope
			echo ""
			Get-NetAdapter | select Name, MacAddress
			echo ""
			ipconfig | FindStr IPv4
			
			echo "`nEnter the MAC Address (with dashes) of the server being reserved. `nUse the above MAC Address if creating a reservation for this server."
			$mac = read-host
			echo "Enter the scopeID that the reservation will be created in"
			$id = read-host
			echo "Enter the IP address for the reserved client or server"
			$ip = read-host
			echo "Enter a name for the reservation"
			$name = read-host
			echo "Enter a description for the reservation"
			$description = read-host
			Add-DhcpServerv4Reservation -ScopeId $id -IPAddress $ip -ClientID $mac -Description $description -name $name
			Get-DhcpServerv4Reservation -ScopeId $id
			Break
		}
		7 {
			Get-DhcpServerv4Scope
			echo "Enter the scopeID the reservation is in"
			$id = read-host
			Get-DhcpServerv4Reservation -ScopeId $id
			echo "Enter the IP address of the reservation being removed"
			$ip = read-host
			Remove-DhcpServerv4Reservation -IPAddress $ip
			Get-DhcpServerv4Reservation -ScopeId $id
			Break
		}
		8 {
			Get-DhcpServerinDC
			echo "`nEnter the DNS name of the server you would like to remove"
			$DNS = read-host
			echo "Enter the IP Address of the server you would like to remove"
			$ip = read-host
			Remove-DhcpServerinDC -DNSName $DNS -IPAddress $ip
			Get-DhcpServerinDC
			Break
		}
		9 {$loop = 9}
		default { echo "Invalid input" }
    }
pause
cls
  }
}

else { exit }