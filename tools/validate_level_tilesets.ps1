param([string]$ProjectRoot = (Split-Path $PSScriptRoot -Parent))
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$project = Get-Content -LiteralPath (Join-Path $ProjectRoot 'Young Poseidon.yyp') -Raw | ConvertFrom-Json -Depth 100
$order = Get-Content -LiteralPath (Join-Path $ProjectRoot 'Young Poseidon.resource_order') -Raw | ConvertFrom-Json -Depth 100
$folders = @{}
foreach ($folder in $project.Folders) { $folders[$folder.folderPath] = $folder.name }
$ids = @('sea', 'coast', 'mines', 'hades', 'greece', 'battlefield', 'olympus')

foreach ($id in $ids) {
    $spriteName = "spr_${id}_tiles"
    $tilesetName = "ts_$id"
    $spriteRelative = "sprites/$spriteName/$spriteName.yy"
    $tilesetRelative = "tilesets/$tilesetName/$tilesetName.yy"
    foreach ($entry in @(@{ Name=$spriteName; Path=$spriteRelative }, @{ Name=$tilesetName; Path=$tilesetRelative })) {
        if (@($project.resources | Where-Object { $_.id.name -eq $entry.Name -and $_.id.path -eq $entry.Path }).Count -ne 1) {
            throw "Project registration is missing or duplicated: $($entry.Name)"
        }
        if (@($order.ResourceOrderSettings | Where-Object { $_.name -eq $entry.Name -and $_.path -eq $entry.Path }).Count -ne 1) {
            throw "Resource order is missing or duplicated: $($entry.Name)"
        }
    }

    $sprite = Get-Content -LiteralPath (Join-Path $ProjectRoot $spriteRelative) -Raw | ConvertFrom-Json -Depth 100
    $tileset = Get-Content -LiteralPath (Join-Path $ProjectRoot $tilesetRelative) -Raw | ConvertFrom-Json -Depth 100
    if ($sprite.resourceType -ne 'GMSprite' -or $sprite.resourceVersion -ne '2.0' -or
        $sprite.width -ne 512 -or $sprite.height -ne 512 -or @($sprite.frames).Count -ne 1) { throw "Invalid sprite metadata: $spriteName" }
    if ($tileset.resourceType -ne 'GMTileSet' -or $tileset.resourceVersion -ne '2.0' -or
        $tileset.tileWidth -ne 64 -or $tileset.tileHeight -ne 64 -or $tileset.tile_count -ne 64 -or
        $tileset.spriteId.name -ne $spriteName -or $tileset.spriteId.path -ne $spriteRelative) { throw "Invalid tileset metadata: $tilesetName" }
    if (-not $folders.ContainsKey($sprite.parent.path) -or $folders[$sprite.parent.path] -ne $sprite.parent.name -or
        -not $folders.ContainsKey($tileset.parent.path) -or $folders[$tileset.parent.path] -ne $tileset.parent.name) { throw "Invalid virtual folder: $id" }

    $frameId = $sprite.frames[0].name
    $layerId = $sprite.layers[0].name
    $channel = $sprite.sequence.tracks[0].keyframes.Keyframes[0].Channels.'0'
    if ($channel.Id.name -ne $frameId -or $channel.Id.path -ne $spriteRelative) { throw "Invalid frame track: $spriteName" }
    $dir = Join-Path $ProjectRoot "sprites/$spriteName"
    $frame = Join-Path $dir "$frameId.png"
    $layer = Join-Path $dir "layers/$frameId/$layerId.png"
    if (-not (Test-Path -LiteralPath $frame) -or -not (Test-Path -LiteralPath $layer)) { throw "Missing frame or layer image: $spriteName" }
    if ((Get-FileHash -LiteralPath $frame).Hash -ne (Get-FileHash -LiteralPath $layer).Hash) { throw "Frame/layer images differ: $spriteName" }
    foreach ($imagePath in @($frame, (Join-Path $ProjectRoot "tilesets/$tilesetName/output_tileset.png"))) {
        $image = [Drawing.Image]::FromFile($imagePath)
        try {
            $expected = if ($imagePath -eq $frame) { 512 } else { 544 }
            if ($image.Width -ne $expected -or $image.Height -ne $expected) { throw "Wrong image dimensions: $imagePath" }
        } finally { $image.Dispose() }
    }
    $atlas = [Drawing.Bitmap]::new($frame)
    $preview = [Drawing.Bitmap]::new((Join-Path $ProjectRoot "tilesets/$tilesetName/output_tileset.png"))
    try {
        for ($index = 1; $index -lt 64; $index++) {
            $sx = ($index % 8) * 64
            $sy = [int][Math]::Floor($index / 8) * 64
            $px = ($index % 8) * 68 + 2
            $py = [int][Math]::Floor($index / 8) * 68 + 2
            for ($y = 0; $y -lt 64; $y += 4) {
                for ($x = 0; $x -lt 64; $x += 4) {
                    if ($atlas.GetPixel($sx + $x, $sy + $y).ToArgb() -ne $preview.GetPixel($px + $x, $py + $y).ToArgb()) {
                        throw "Tile index shifted in $tilesetName at index $index"
                    }
                }
            }
        }
    } finally { $atlas.Dispose(); $preview.Dispose() }
    Write-Host "PASS: $spriteName -> $tilesetName"
}

foreach ($id in $ids) {
    for ($number = 1; $number -le 5; $number++) {
        $room = "rm_${id}_$number"
        $path = Join-Path $ProjectRoot "rooms/$room/$room.yy"
        $resource = Get-Content -LiteralPath $path -Raw | ConvertFrom-Json -Depth 100
        $layers = @($resource.layers | Where-Object { $_.resourceType -eq 'GMRTileLayer' })
        if ($layers.Count -ne 1 -or $layers[0].tilesetId.name -ne "ts_$id" -or
            $layers[0].tilesetId.path -ne "tilesets/ts_$id/ts_$id.yy") {
            throw "Wrong tile layer in $room"
        }
        $values = @()
        $data = $layers[0].tiles.TileCompressedData
        for ($i = 0; $i -lt $data.Count;) {
            $count = [int]$data[$i++]
            if ($count -lt 0) {
                $value = [int]$data[$i++]
                for ($j = 0; $j -lt -$count; $j++) { $values += $value }
            } elseif ($count -gt 0) {
                for ($j = 0; $j -lt $count; $j++) { $values += [int]$data[$i++] }
            } else { throw "Zero-length tile run in $room" }
        }
        if ($values.Count -ne 160 -or @($values | Where-Object { $_ -lt 0 -or $_ -ge 64 }).Count) {
            throw "Invalid tile data in $room"
        }
        if (@($values[144..159] | Where-Object { $_ -eq 0 }).Count) { throw "Unpainted floor in $room" }
    }
}
Write-Host 'PASS: 35 rooms have one matching, populated tile layer.'
