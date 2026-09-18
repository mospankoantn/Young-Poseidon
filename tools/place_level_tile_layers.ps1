param([string]$ProjectRoot = (Split-Path $PSScriptRoot -Parent))
$ErrorActionPreference = 'Stop'
$utf8 = [Text.UTF8Encoding]::new($false)
$templateRoom = Get-Content -LiteralPath (Join-Path $ProjectRoot 'rooms/rm_sea_3/rm_sea_3.yy') -Raw | ConvertFrom-Json -Depth 100
$templateLayer = @($templateRoom.layers | Where-Object { $_.resourceType -eq 'GMRTileLayer' })[0]
if (-not $templateLayer) { throw 'Missing sea tile layer template' }

$themes = @('sea', 'coast', 'mines', 'hades', 'greece', 'battlefield', 'olympus')
$added = 0
foreach ($theme in $themes) {
    for ($number = 1; $number -le 5; $number++) {
        $name = "rm_${theme}_$number"
        $path = Join-Path $ProjectRoot "rooms/$name/$name.yy"
        $room = Get-Content -LiteralPath $path -Raw | ConvertFrom-Json -Depth 100
        $existing = @($room.layers | Where-Object { $_.resourceType -eq 'GMRTileLayer' })
        if ($existing.Count -gt 0) {
            if ($existing.Count -ne 1 -or $existing[0].tilesetId.name -ne "ts_$theme") {
                throw "Unexpected tile layer in $name"
            }
            continue
        }
        if ($room.roomSettings.Width -ne 1000 -or $room.roomSettings.Height -ne 640) {
            throw "Unexpected room size in $name"
        }
        $layer = $templateLayer | ConvertTo-Json -Depth 100 | ConvertFrom-Json -Depth 100
        $layer.tilesetId.name = "ts_$theme"
        $layer.tilesetId.path = "tilesets/ts_$theme/ts_$theme.yy"
        if ($theme -eq 'sea') {
            $floor = @(8, 9, 10, 9, 10, 10, 9, 9, 10, 8, 10, 9, 10, 9, 10, 8)
            $layer.tiles.TileCompressedData = @(-16, 11, -64, 1, -64, 1, 16) + $floor
        } else {
            $floor = @(0..15 | ForEach-Object { [int](8 + (($_ + $number - 1) % 8)) })
            $layer.tiles.TileCompressedData = @(-64, 0, -64, 0, -16, 0, 16) + $floor
        }
        $background = @($room.layers | Where-Object { $_.resourceType -eq 'GMRBackgroundLayer' })
        foreach ($bg in $background) {
            if ($bg.depth -le $layer.depth) { $bg.depth = $layer.depth + 100 }
        }
        $room.layers += $layer
        [IO.File]::WriteAllText($path, ($room | ConvertTo-Json -Depth 100) + "`n", $utf8)
        $added++
        Write-Host "$name -> ts_$theme (16 floor tiles)"
    }
}
Write-Host "Added $added tile layers; preserved existing sea layouts."
