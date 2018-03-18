Get-EventLog Application >> All_Events.txt
Get-EventLog System >> All_Events.txt

findstr /g:Sort_Event_IDs/User_IDs.txt All_Events.txt > Temp.txt
Get-Content "Temp.txt" | Where-Object {$_ -match "Error"} > User_Accounts.txt
Get-Content "Temp.txt" | Where-Object {$_ -match "Warning"} >> User_Accounts.txt
Get-Content "Temp.txt" | Where-Object {$_ -match "Information"} >> User_Accounts.txt
Remove-Item Temp.txt

findstr /g:Sort_Event_IDs/Group_IDs.txt All_Events.txt > Temp.txt
Get-Content "Temp.txt" | Where-Object {$_ -match "Error"} > Group.txt
Get-Content "Temp.txt" | Where-Object {$_ -match "Warning"} >> Group.txt
Get-Content "Temp.txt" | Where-Object {$_ -match "Information"} >> Group.txt
Remove-Item Temp.txt

findstr /g:Sort_Event_IDs/Logon_IDs.txt All_Events.txt > Temp.txt
Get-Content "Temp.txt" | Where-Object {$_ -match "Error"} > Logon.txt
Get-Content "Temp.txt" | Where-Object {$_ -match "Warning"} >> Logon.txt
Get-Content "Temp.txt" | Where-Object {$_ -match "Information"} >> Logon.txt
Remove-Item Temp.txt

findstr /g:Sort_Event_IDs/Power_IDs.txt All_Events.txt > Temp.txt
Get-Content "Temp.txt" | Where-Object {$_ -match "Error"} > Power_Shutdown.txt
Get-Content "Temp.txt" | Where-Object {$_ -match "Warning"} >> Power_Shutdown.txt
Get-Content "Temp.txt" | Where-Object {$_ -match "Information"} >> Power_Shutdown.txt
Remove-Item Temp.txt