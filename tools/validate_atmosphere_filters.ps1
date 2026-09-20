param([string]$ProjectRoot = (Split-Path $PSScriptRoot -Parent))
$ErrorActionPreference = 'Stop'

$zones = [ordered]@{
    sea         = 'obj_underwater_filter'
    coast       = 'obj_coast_filter'
    mines       = 'obj_mines_filter'
    hades       = 'obj_hades_filter'
    greece      = 'obj_greece_filter'
    battlefield = 'obj_battlefield_filter'
    olympus     = 'obj_olympus_filter'
}

foreach ($pair in $zones.GetEnumerator()) {
    $zone = $pair.Key
    $objectName = $pair.Value
    $objectDir = Join-Path $ProjectRoot "objects/$objectName"
    $yyPath = Join-Path $objectDir "$objectName.yy"
    $createPath = Join-Path $objectDir 'Create_0.gml'
    $drawPath = Join-Path $objectDir 'Draw_73.gml'

    foreach ($path in @($yyPath, $createPath, $drawPath)) {
        if (-not (Test-Path -LiteralPath $path)) { throw "Missing atmospheric file: $path" }
    }

    $resource = Get-Content -LiteralPath $yyPath -Raw | ConvertFrom-Json -Depth 100
    if ($resource.resourceType -ne 'GMObject' -or $resource.resourceVersion -ne '2.0') {
        throw "Invalid atmospheric object metadata: $objectName"
    }
    if (@($resource.eventList | Where-Object { $_.eventType -eq 0 -and $_.eventNum -eq 0 }).Count -ne 1 -or
        @($resource.eventList | Where-Object { $_.eventType -eq 8 -and $_.eventNum -eq 73 }).Count -ne 1) {
        throw "Atmospheric object must have Create + Draw End: $objectName"
    }

    $draw = Get-Content -LiteralPath $drawPath -Raw
    if ($draw -notmatch 'delta_time' -or $draw -notmatch 'gpu_set_blendmode\(bm_normal\)') {
        throw "Atmospheric draw event lacks frame-independent timing or blend reset: $objectName"
    }
    if ($draw -match 'draw_set_blend_mode') {
        throw "Invalid GameMaker blend function found: $objectName"
    }

    for ($number = 1; $number -le 5; $number++) {
        $roomName = "rm_${zone}_$number"
        $roomPath = Join-Path $ProjectRoot "rooms/$roomName/$roomName.yy"
        $room = Get-Content -LiteralPath $roomPath -Raw | ConvertFrom-Json -Depth 100
        $instances = @()
        foreach ($layer in @($room.layers | Where-Object { $_.resourceType -eq 'GMRInstanceLayer' })) {
            $instances += @($layer.instances | Where-Object { $_.objectId.name -eq $objectName })
        }
        if ($instances.Count -ne 1) { throw "$roomName must contain exactly one $objectName (found $($instances.Count))" }
        $instanceName = $instances[0].name
        if (@($room.instanceCreationOrder | Where-Object { $_.name -eq $instanceName }).Count -ne 1) {
            throw "$roomName is missing $instanceName in instanceCreationOrder"
        }
    }
    Write-Host "PASS: $zone -> $objectName in rooms 1-5"
}

Write-Host 'PASS: all 35 campaign rooms have exactly one matching atmospheric filter.'
