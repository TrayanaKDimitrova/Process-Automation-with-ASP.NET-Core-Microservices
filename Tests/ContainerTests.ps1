$count = 0
do {
    $count++
    Write-Output "[$env:STAGE_NAME] Starting container [Attempt: $count]"
    
	Write-Output "Start test load pages"
    $testStart = Invoke-WebRequest -Uri http://localhost -UseBasicParsing
	$adminPanelStart = Invoke-WebRequest -Uri http://localhost:5000/ -UseBasicParsing
	$watchdogStart = Invoke-WebRequest -Uri http://localhost:5500/healthchecks -UseBasicParsing
    $statisticsStart = Invoke-WebRequest -Uri http://localhost:5003/statistics -UseBasicParsing
    $carPageStart = Invoke-WebRequest -Uri http://localhost:5002/carads/ -UseBasicParsing
    
	Write-Output "Test nomeclature"
	$nomeclatureLoad = Invoke-WebRequest -Uri http://localhost:5002/carads/categories -UseBasicParsing
	
	Write-Output "Test load create page"
	$createPage = Invoke-WebRequest -Uri http://localhost/cars/create - -UseBasicParsing

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
	
	if ($statisticsStart.statuscode -eq '200') {
        $started = $true
    } else {
        Start-Sleep -Seconds 1
    }
	
	if ($carPageStart.statuscode -eq '200') {
        $started = $true
    } else {
        Start-Sleep -Seconds 1
    }
	if ($nomeclatureLoad.statuscode -eq '200') {
        $started = $true
    } else {
        Start-Sleep -Seconds 1
    }
	if ($createPage.statuscode -eq '200') {
        $started = $true
    } else {
        Start-Sleep -Seconds 1
    }
} until ($started -or ($count -eq 3))

if (!$started) {
    exit 1
}
