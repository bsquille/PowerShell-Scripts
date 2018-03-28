# Lines 2-8 Check whether the terminal is running with Admin privaledge, if not it opens an Admin terminal and imports all code below to the Admin terminal.
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))

{   
$arguments = "& '" + $myinvocation.mycommand.definition + "'"
Start-Process powershell -Verb runAs -ArgumentList $arguments
Break
}

[int]$temp = -1
While ($temp -ne 9) {

netdom query fsmo
echo "`n0 — PDCEmulator `n1 — RIDMaster `n2 — InfrastructureMaster `n3 — Schema Master `n4 — DomainNamingMaster `n9 - Quit" 
echo "Enter the role you would like to transfer to a different server (0-4)"
$switch = read-host
if ($switch -eq 9) {Exit}
echo "Enter the hostname of the server you would like to transfer the FSMO role to. ex.(DC1)"
$ID = read-host

Switch ($switch) {

	0 { 
		Move-ADDirectoryServerOperationMasterRole -Identity $ID -OperationMasterRole 0
		Break 
	}
	1 { 
		Move-ADDirectoryServerOperationMasterRole -Identity $ID -OperationMasterRole 1
		Break 
	}
	2 { 
		Move-ADDirectoryServerOperationMasterRole -Identity $ID -OperationMasterRole 2
		Break 
	}
	3 { 
		Move-ADDirectoryServerOperationMasterRole -Identity $ID -OperationMasterRole 3
		Break 
	}
	4 { 
		Move-ADDirectoryServerOperationMasterRole -Identity $ID -OperationMasterRole 4
		Break 
	}
	9 { 
		$temp = 9
		Break
	 }
	default { echo "Invalid input" }
} 
}