param([string]$ProjectRoot = (Split-Path $PSScriptRoot -Parent))
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
Add-Type -ReferencedAssemblies System.Drawing,System.Drawing.Primitives,System.Drawing.Common -TypeDefinition @'
using System;
using System.Drawing;
using System.Drawing.Imaging;

public static class TilePreview {
    public static Bitmap Build(Bitmap atlas) {
        var output = new Bitmap(544, 544, PixelFormat.Format32bppArgb);
        for (int y = 0; y < 64; y++) {
            for (int x = 0; x < 64; x++) {
                output.SetPixel(x + 2, y + 2, ((x / 16 + y / 16) % 2 == 0) ? Color.Black : Color.White);
            }
        }
        for (int index = 1; index < 64; index++) {
            int sourceX = (index % 8) * 64;
            int sourceY = (index / 8) * 64;
            int destX = (index % 8) * 68;
            int destY = (index / 8) * 68;
            for (int y = 0; y < 68; y++) {
                for (int x = 0; x < 68; x++) {
                    int tileX = Math.Clamp(x - 2, 0, 63);
                    int tileY = Math.Clamp(y - 2, 0, 63);
                    output.SetPixel(destX + x, destY + y, atlas.GetPixel(sourceX + tileX, sourceY + tileY));
                }
            }
        }
        return output;
    }
}
'@

$referencePath = Join-Path $ProjectRoot 'Файли/tiles_reference_2026.png'
$seaFrame = 'abecefd3-acfc-4cc5-b3b1-5e4d0db84a78'
$seaLayer = 'f8f26872-df30-47e9-978e-3de1db90f9df'
$zones = @(
    @{ Id='sea'; X=6; Start=32; Highlight='#FFE189'; Shadow='#77572F' },
    @{ Id='coast'; X=221; Start=0; Highlight='#F8DC9C'; Shadow='#775E47' },
    @{ Id='mines'; X=440; Start=0; Highlight='#91A0B0'; Shadow='#232A37' },
    @{ Id='hades'; X=655; Start=0; Highlight='#9DA36D'; Shadow='#332B3D' },
    @{ Id='greece'; X=870; Start=0; Highlight='#FFF1C9'; Shadow='#8796A3' },
    @{ Id='battlefield'; X=1084; Start=0; Highlight='#E7AE83'; Shadow='#4A2D32' },
    @{ Id='olympus'; X=1314; Start=0; Highlight='#FFF9E2'; Shadow='#91BED1' }
)

$utf8 = [Text.UTF8Encoding]::new($false)
function Clone-Json($value) { $value | ConvertTo-Json -Depth 100 | ConvertFrom-Json -Depth 100 }
function Save-Json($path, $value) { [IO.File]::WriteAllText($path, ($value | ConvertTo-Json -Depth 100) + "`n", $utf8) }

function Draw-Cell($target, $source, $index, $zone) {
    $col = $index % 8
    $row = [int][Math]::Floor($index / 8)
    $x = $col * 64
    $y = $row * 64
    $variant = $index % 8
    $sampleX = $zone.X + 10 + ($variant * 18)
    $sampleY = switch ($row) {
        0 { 251 }
        1 { 313 }
        2 { 300 }
        3 { 317 }
        4 { 176 }
        5 { 402 }
        6 { 464 }
        default { 256 }
    }
    if ($row -eq 2 -or $row -eq 3) { $sampleX = $zone.X + 73 + ($variant * 10) }
    if ($row -eq 4) { $sampleX = $zone.X + 70 + ($variant * 10) }
    $sampleX = [Math]::Min($zone.X + 143, $sampleX)

    $small = [Drawing.Bitmap]::new(32, 32, [Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $sampleGraphics = [Drawing.Graphics]::FromImage($small)
    $sampleGraphics.InterpolationMode = [Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $sampleGraphics.DrawImage($source, [Drawing.Rectangle]::new(0, 0, 32, 32), [Drawing.Rectangle]::new($sampleX, $sampleY, 64, 64), [Drawing.GraphicsUnit]::Pixel)
    $sampleGraphics.Dispose()

    $g = [Drawing.Graphics]::FromImage($target)
    try {
        $g.InterpolationMode = [Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
        $g.PixelOffsetMode = [Drawing.Drawing2D.PixelOffsetMode]::Half
        $g.DrawImage($small, [Drawing.Rectangle]::new($x, $y, 64, 64), [Drawing.Rectangle]::new(0, 0, 32, 32), [Drawing.GraphicsUnit]::Pixel)
        $light = [Drawing.SolidBrush]::new([Drawing.ColorTranslator]::FromHtml($zone.Highlight))
        $dark = [Drawing.SolidBrush]::new([Drawing.ColorTranslator]::FromHtml($zone.Shadow))
        try {
            if ($row -eq 1 -or $row -eq 2) {
                $g.FillRectangle($dark, $x, $y + 6, 64, 3)
                $g.FillRectangle($light, $x, $y, 64, 5)
            }
            if ($row -eq 2 -and ($variant % 2) -eq 0) { $g.FillRectangle($dark, $x, $y, 4, 64) }
            if ($row -eq 2 -and ($variant % 2) -eq 1) { $g.FillRectangle($dark, $x + 60, $y, 4, 64) }
            if ($row -eq 3) {
                $g.FillRectangle($dark, $x, $y + 58, 64, 6)
                if (($variant % 2) -eq 0) { $g.FillRectangle($light, $x + 4, $y + 4, 3, 50) }
            }
            if ($row -eq 7) {
                $g.FillRectangle($light, $x + 4, $y + 4, 56, 3)
                $g.FillRectangle($dark, $x + 4, $y + 55, 56, 5)
            }
        } finally {
            $light.Dispose()
            $dark.Dispose()
        }
    } finally {
        $g.Dispose()
        $small.Dispose()
    }
}

$projectPath = Join-Path $ProjectRoot 'Young Poseidon.yyp'
$orderPath = Join-Path $ProjectRoot 'Young Poseidon.resource_order'
$project = Get-Content -LiteralPath $projectPath -Raw | ConvertFrom-Json -Depth 100
$order = Get-Content -LiteralPath $orderPath -Raw | ConvertFrom-Json -Depth 100
$spriteTemplate = Get-Content -LiteralPath (Join-Path $ProjectRoot 'sprites/spr_sea_tiles/spr_sea_tiles.yy') -Raw | ConvertFrom-Json -Depth 100
$tilesetTemplate = Get-Content -LiteralPath (Join-Path $ProjectRoot 'tilesets/ts_sea/ts_sea.yy') -Raw | ConvertFrom-Json -Depth 100
$known = @{}
foreach ($entry in $project.resources) { $known[$entry.id.name] = $entry.id.path }
$ordered = @{}
foreach ($entry in $order.ResourceOrderSettings) { $ordered[$entry.name] = $true }
$nextSpriteOrder = [int](1 + (($order.ResourceOrderSettings | Where-Object { $_.path -like 'sprites/*' } | Measure-Object order -Maximum).Maximum))
$nextTilesetOrder = [int](1 + (($order.ResourceOrderSettings | Where-Object { $_.path -like 'tilesets/*' } | Measure-Object order -Maximum).Maximum))
$tileFolder = 'folders/Tile Sets.yy'
if (-not @($project.Folders | Where-Object folderPath -eq $tileFolder).Count) {
    $project.Folders += [pscustomobject][ordered]@{ '$GMFolder'=''; '%Name'='Tile Sets'; folderPath=$tileFolder; name='Tile Sets'; resourceType='GMFolder'; resourceVersion='2.0' }
}
if (-not @($order.FolderOrderSettings | Where-Object path -eq $tileFolder).Count) {
    $order.FolderOrderSettings += [pscustomobject][ordered]@{ name='Tile Sets'; order=16; path=$tileFolder }
}

$source = [Drawing.Bitmap]::new($referencePath)
try {
    if ($source.Width -ne 1536 -or $source.Height -ne 1024) { throw "Unexpected reference size: $($source.Width)x$($source.Height)" }
    foreach ($zone in $zones) {
        $id = $zone.Id
        $spriteName = "spr_${id}_tiles"
        $tilesetName = "ts_$id"
        $spriteRelative = "sprites/$spriteName/$spriteName.yy"
        $tilesetRelative = "tilesets/$tilesetName/$tilesetName.yy"
        $spriteDir = Join-Path $ProjectRoot "sprites/$spriteName"
        $tilesetDir = Join-Path $ProjectRoot "tilesets/$tilesetName"
        [IO.Directory]::CreateDirectory($spriteDir) | Out-Null
        [IO.Directory]::CreateDirectory($tilesetDir) | Out-Null

        if ($id -eq 'sea') {
            $sprite = $spriteTemplate
            $frameId = $seaFrame
            $layerId = $seaLayer
            $original = [Drawing.Bitmap]::new((Join-Path $spriteDir "$frameId.png"))
            try { $bitmap = [Drawing.Bitmap]$original.Clone() }
            finally { $original.Dispose() }
            $tileset = $tilesetTemplate
        } else {
            $spritePath = Join-Path $spriteDir "$spriteName.yy"
            $tilesetPath = Join-Path $tilesetDir "$tilesetName.yy"
            if (Test-Path -LiteralPath $spritePath) {
                $sprite = Get-Content -LiteralPath $spritePath -Raw | ConvertFrom-Json -Depth 100
                $frameId = $sprite.frames[0].name
                $layerId = $sprite.layers[0].name
            } else {
                $sprite = Clone-Json $spriteTemplate
                $frameId = [guid]::NewGuid().ToString()
                $layerId = [guid]::NewGuid().ToString()
                $sprite.frames[0].name = $frameId
                $sprite.frames[0].'%Name' = $frameId
                $sprite.layers[0].name = $layerId
                $sprite.layers[0].'%Name' = $layerId
                $sprite.sequence.tracks[0].keyframes.Keyframes[0].id = [guid]::NewGuid().ToString()
            }
            $tileset = if (Test-Path -LiteralPath $tilesetPath) {
                Get-Content -LiteralPath $tilesetPath -Raw | ConvertFrom-Json -Depth 100
            } else { Clone-Json $tilesetTemplate }
            $bitmap = [Drawing.Bitmap]::new(512, 512, [Drawing.Imaging.PixelFormat]::Format32bppArgb)
            $sprite.name = $spriteName
            $sprite.'%Name' = $spriteName
            $sprite.sequence.name = $spriteName
            $sprite.sequence.'%Name' = $spriteName
            $sprite.sequence.tracks[0].keyframes.Keyframes[0].Channels.'0'.Id.name = $frameId
            $sprite.sequence.tracks[0].keyframes.Keyframes[0].Channels.'0'.Id.path = $spriteRelative
            $sprite.parent.name = 'World'
            $sprite.parent.path = 'folders/Спрайты/World.yy'
        }
        try {
            for ($index = $zone.Start; $index -lt 64; $index++) { Draw-Cell $bitmap $source $index $zone }
            $framePath = Join-Path $spriteDir "$frameId.png"
            $tempFramePath = Join-Path $spriteDir "$frameId.new.png"
            $bitmap.Save($tempFramePath, [Drawing.Imaging.ImageFormat]::Png)

            $previewSource = [Drawing.Bitmap]::new($tempFramePath)
            try {
                $preview = [TilePreview]::Build($previewSource)
                try { $preview.Save((Join-Path $tilesetDir 'output_tileset.png'), [Drawing.Imaging.ImageFormat]::Png) }
                finally { $preview.Dispose() }
            } finally { $previewSource.Dispose() }
        } finally { $bitmap.Dispose() }
        Move-Item -LiteralPath $tempFramePath -Destination $framePath -Force
        $layerDir = Join-Path $spriteDir "layers/$frameId"
        [IO.Directory]::CreateDirectory($layerDir) | Out-Null
        Copy-Item -LiteralPath $framePath -Destination (Join-Path $layerDir "$layerId.png") -Force

        if ($id -ne 'sea') {
            Save-Json (Join-Path $spriteDir "$spriteName.yy") $sprite
            if (-not $known.ContainsKey($spriteName)) {
                $project.resources += [pscustomobject]@{ id=[pscustomobject]@{ name=$spriteName; path=$spriteRelative } }
                $known[$spriteName] = $spriteRelative
            }
            if (-not $ordered.ContainsKey($spriteName)) {
                $order.ResourceOrderSettings += [pscustomobject]@{ name=$spriteName; order=[int]$nextSpriteOrder; path=$spriteRelative }
                $ordered[$spriteName] = $true
                $nextSpriteOrder++
            }
        }
        $tileset.name = $tilesetName
        $tileset.'%Name' = $tilesetName
        $tileset.parent.name = 'Tile Sets'
        $tileset.parent.path = $tileFolder
        $tileset.spriteId.name = $spriteName
        $tileset.spriteId.path = $spriteRelative
        Save-Json (Join-Path $tilesetDir "$tilesetName.yy") $tileset
        if ($id -ne 'sea') {
            if (-not $known.ContainsKey($tilesetName)) {
                $project.resources += [pscustomobject]@{ id=[pscustomobject]@{ name=$tilesetName; path=$tilesetRelative } }
                $known[$tilesetName] = $tilesetRelative
            }
            if (-not $ordered.ContainsKey($tilesetName)) {
                $order.ResourceOrderSettings += [pscustomobject]@{ name=$tilesetName; order=[int]$nextTilesetOrder; path=$tilesetRelative }
                $ordered[$tilesetName] = $true
                $nextTilesetOrder++
            }
        }
        Write-Host "$spriteName -> $tilesetName"
    }
} finally { $source.Dispose() }
Save-Json $projectPath $project
Save-Json $orderPath $order
