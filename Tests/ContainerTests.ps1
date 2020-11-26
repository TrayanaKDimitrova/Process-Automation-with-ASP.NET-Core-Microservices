$count = 0
do {
    $count++
    Write-Output "[$env:STAGE_NAME] Starting container [Attempt: $count]"
    
    $testStart = Invoke-WebRequest -Uri http://localhost -UseBasicParsing
	$adminPanelStart = Invoke-WebRequest -Uri http://localhost:5000/ -UseBasicParsing
	$watchdogStart = Invoke-WebRequest -Uri http://localhost:5500/healthchecks -UseBasicParsing
    
    if ($testStart.statuscode -eq '200') {
        $started = $true
    } else {
        Start-Sleep -Seconds 1
    }
	
	if ($adminPanelStart.statuscode -eq '200') {
        $started = $true
    } else {
        Start-Sleep -Seconds 1
    }
	if ($watchdogStart.statuscode -eq '200') {
        $started = $true
    } else {
        Start-Sleep -Seconds 1
    }
    
} until ($started -or ($count -eq 3))

if (!$started) {
    exit 1
}
