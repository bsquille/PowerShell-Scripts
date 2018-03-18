echo "Enter R0"
$R0 = read-host
echo = "Enter R1"
$R1 = read-host
$GCD = 1

while ($GCD -ne 0) {

	$GCD = $R0 % $R1
	$R0 = $R1
	$R1 = $GCD

}

echo "GCD = $R0"
pause