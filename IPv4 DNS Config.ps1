# Lines 2-8 Check whether the terminal is running with Admin privaledge, if not it opens an Admin terminal and imports all code below to the Admin terminal.
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))

{   
$arguments = "& '" + $myinvocation.mycommand.definition + "'"
Start-Process powershell -Verb runAs -ArgumentList $arguments
Break
}

[int]$temp = -1
While ($temp -ne 0) {

echo "1 - Create new host (A record)"
echo "2 - Remove a host (A record)"
echo "3 - Create new alias (CNAME)"
echo "4 - Remove an alias (CNAME)"
echo "5 - Add new Primary Forward Lookup Zone"
echo "6 - Remove Primary Lookup Zone (Forward or Reverse)"
echo "7 - Add new Primary Reverse Lookup Zone"
echo "8 - Create PTR for Reverse Lookup Zone"
echo "9 - Remove PTR for Reverse Lookup Zone"
echo "0 - Exit"

$switch = read-host

Switch ($switch) {

	1 {
		Get-DnsServerZone
		echo "`nEnter the zone name"
		$zone = read-host
		echo "Enter the name of the host (no spaces)"
		$name = read-host
		echo "Enter the IP Address of the host"
		$IP = read-host
		echo "Would you like to create an associated pointer (PTR) record? (y or n)"
		$PTR = read-host
		
		if ($PTR -eq "y") {
			Add-DnsServerResourceRecord -A -IPv4Address $IP -Name $name -ZoneName $zone -CreatePtr
		}
		elseif ($PTR -eq "n") {
			Add-DnsServerResourceRecord -A -IPv4Address $IP -Name $name -ZoneName $zone
		}
		else {
			echo "Invalid input"
		}
		
		
	Break

	}
	2 {	
		Get-DnsServerZone
		echo "`nEnter the zone name"
		$zone = read-host
		Get-DnsServerResourceRecord -ZoneName $zone -RRType A
		echo "`nEnter the HostName of the host being removed"
		$name = read-host
		Remove-DnsServerResourceRecord -Name $name -RRType A -ZoneName $zone
	
	Break
	}
	3 {	
		Get-DnsServerZone
		echo "`nEnter the zone name"
		$zone = read-host
		Get-DnsServerResourceRecord -ZoneName $zone -RRType A
		echo "`nEnter the name of the host you are creating the alias for ex.(dc1.test.com)"
		$name = read-host
		echo "Enter the alias you would like to use"
		$alias = read-host
		Add-DnsServerResourceRecord -CName -HostNameAlias $name -Name $alias -ZoneName $zone -Confirm
		Get-DnsServerResourceRecord -ZoneName $zone -RRType CName
	
	Break
	}
	4 {	
		Get-DnsServerZone
		echo "`nEnter the zone name"
		$zone = read-host
		Get-DnsServerResourceRecord -ZoneName $zone -RRType CName
		echo "`nEnter the HostName of the alias you are removing"
		$name = read-host
		Remove-DnsServerResourceRecord -Name $name -RRType CName -ZoneName $zone
	
	Break
	}
	5 {	
		echo "Enter the name of the new zone. ex.(testing.com)"
		$name = read-host
		[int]$temp = 0
		while ($temp -ne 1) {
		echo "Enter the replication scope"
		echo "Options {Domain} {Forest} {Legacy} default is typically Domain"
		$scope = read-host
		
		if ($scope -eq "Domain") {
			Add-DnsServerPrimaryZone -Name $name -ReplicationScope Domain
			$temp = 1
		}
		elseif ($scope -eq "Forest") {
			Add-DnsServerPrimaryZone -Name $name -ReplicationScope Forest
			$temp = 1
		}
		elseif ($scope -eq "Legacy") {
			Add-DnsServerPrimaryZone -Name $name -ReplicationScope Legacy
			$temp = 1
		}
		else {
			echo "Invalid scope `n "
		}}
		Get-DnsServerZone
	
	Break
	}
	6 {
		Get-DnsServerZone
		echo "`nEnter the name of the zone you would like to remove"
		$name = read-host
		Remove-DnsServerZone -Name $name
		Get-DnsServerZone
	Break
	}
	7 {	
		echo "Enter the network ID of the new zone. ex.(192.168.1.0/24)"
		$netID = read-host
		[int]$temp = 0
		while ($temp -ne 1) {
		echo "Enter the replication scope"
		echo "Options {Domain} {Forest} {Legacy} default is typically Domain"
		$scope = read-host
		
		if ($scope -eq "Domain") {
			Add-DnsServerPrimaryZone -NetworkID $netID -ReplicationScope Domain -DynamicUpdate Secure
			echo "Dynamic update set to secure (Default)"
			$temp = 1
		}
		elseif ($scope -eq "Forest") {
			Add-DnsServerPrimaryZone -NetworkID $netID -ReplicationScope Forest -DynamicUpdate Secure
			echo "Dynamic update set to secure (Default)"
			$temp = 1
		}
		elseif ($scope -eq "Legacy") {
			Add-DnsServerPrimaryZone -NetworkID $netID -ReplicationScope Legacy -DynamicUpdate Secure
			echo "Dynamic update set to secure (Default)"
			$temp = 1
		}
		else {
			echo "Invalid scope `n "
		}}
		Get-DnsServerZone
	
	Break
	}
	8 {
		Get-DnsServerZone
		echo "`nEnter the name of the zone you would like to add a PTR to. ex.(1.168.192.inaddr.arpa)"
		$zone = read-host
		echo "Enter the host portion of the IP address. ex.(If the IP address is 192.168.1.25/24, enter 25)"
		[int]$IP = read-host
		echo "Enter the full domain name of the host. ex.(dc1.test.com)"
		$name = read-host
		Add-DnsServerResourceRecordPtr -Name $IP -PtrDomainName $name -ZoneName $zone
		Get-DnsServerResourceRecord -ZoneName $zone -RRType Ptr
	Break
	}
	9 {
		Get-DnsServerZone
		echo "`nEnter the name of the zone you would like to add a PTR to. ex.(1.168.192.inaddr.arpa)"
		$zone = read-host
		Get-DnsServerResourceRecord -ZoneName $zone -RRType Ptr
		echo "`nEnter the HostName of the PTR you would like to remove"
		$name = read-host
		Remove-DnsServerResourceRecord -Name $name -RRType Ptr -ZoneName $zone
		Get-DnsServerResourceRecord -ZoneName $zone -RRType Ptr
	Break
	}
	0 { 
	$temp = 0 
	}
	default { 
	echo "Invalid input" 
	}

}
pause
cls
}