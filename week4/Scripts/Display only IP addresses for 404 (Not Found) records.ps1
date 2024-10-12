$notfounds = Get-Content C:\xampp\apache\logs\access.log | Select-String ' 404 '

$regex = [regex] "\b(?:\d{1,3}\.){3}\d{1,3}\b"

$ipsunorganized = $regex.Matches($notfounds)

$ips = @()
for($i=0; $i -lt $ipsunorganized.Count; $i++){
 $ips += [pscustomobject]@{ "IP" = $ipsunorganized[$i].Value; }
}
$ips | Where-Object { $_.IP -like "10.*" }