echo "a(Xo)+c mod m"
echo "Enter the modulus, m (m>0)"
[int]$mod = read-host
echo "Enter the multiplier, a (0<a<m)"
[int]$mult = read-host
echo "Enter the increment, c (0<= c <m)"
[int]$inc = read-host
echo "Enter the seed or starting value, Xo (0 <= Xo <m)"
[int]$seed = read-host

[int]$temp = (($mult*$seed)+$inc)%$mod

write-host "$temp"
[int]$text = $temp
echo "$mult($seed)+$inc mod $mod = $text" > Answers.txt

while ($temp -ne $seed) {
	[int]$text2 = $temp
	[int]$temp2 = (($mult*$temp)+$inc)%$mod
	[int]$temp = [int]$temp2
	write-host "$temp"
	[int]$text = $temp
	echo "$mult($text2)+$inc mod $mod = $text" >> Answers.txt
	}
	
pause