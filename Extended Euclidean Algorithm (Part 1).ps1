echo "Input @n"
$nn = read-host
echo "Input e"
$e = read-host

echo "$e d + $nn y = 1" > test.txt
echo "`n" >> test.txt

$div = 0
$mod = 0

while ($mod -ne 1) {

	$div = [math]::truncate($nn/$e)
	$mod = $nn%$e
	echo "$nn = $e($div) + $mod  =>  $mod = $nn - $e($div)" >> test.txt
	$nn = $e
	$e = $mod
 
}



pause