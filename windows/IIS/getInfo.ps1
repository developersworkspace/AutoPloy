$t = Get-Counter -Counter "\Web Service(*)\Get Requests/sec"
$t = Get-Counter -Counter "\Web Service(*)\Current Connections"

$t.CounterSamples[0].RawValue