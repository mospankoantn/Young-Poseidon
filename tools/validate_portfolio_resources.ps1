param([string]$ProjectRoot=(Split-Path $PSScriptRoot -Parent))
$ErrorActionPreference='Stop'
Add-Type -AssemblyName System.Drawing
function Read-Json($p) {Get-Content -LiteralPath (Join-Path $ProjectRoot $p) -Raw | ConvertFrom-Json -Depth 100}
$project=Read-Json 'Young Poseidon.yyp'
$paths=@{};foreach($r in $project.resources) {$paths[$r.id.path]=$true}
$folders=@{};foreach($f in $project.Folders) {$folders[$f.folderPath]=$true}
function Check-References($value,$source) {
    if($null -eq $value -or $value -is [string] -or $value -is [ValueType]) {return}
    if($value -is [array]) {foreach($item in $value) {Check-References $item $source};return}
    if($value.PSObject.Properties['path'] -and $value.path -like '*.yy') {
        if(!$paths.ContainsKey($value.path) -and !$folders.ContainsKey($value.path)) {throw "Missing reference in $($source): $($value.path)"}
    }
    if($value.PSObject.Properties['resourceType'] -and $value.resourceVersion -ne '2.0') {throw "Missing/wrong resourceVersion in $source"}
    foreach($p in $value.PSObject.Properties) {Check-References $p.Value $source}
}
$frames=0;$sounds=0
foreach($r in $project.resources) {
    $yy=Read-Json $r.id.path;Check-References $yy $r.id.path
    if($yy.resourceType -eq 'GMSprite') {
        if($yy.sequence.length -ne $yy.frames.Count) {throw "Sequence length: $($yy.name)"}
        $keys=$yy.sequence.tracks[0].keyframes.Keyframes
        if($keys.Count -ne $yy.frames.Count) {throw "Sequence track count: $($yy.name)"}
        foreach($frame in $yy.frames) {
            $dir="sprites/$($yy.name)"
            $png=Join-Path $ProjectRoot "$dir/$($frame.name).png"
            if(!(Test-Path -LiteralPath $png)) {throw "Missing composite: $png"}
            foreach($layer in $yy.layers) {
                if(!(Test-Path -LiteralPath (Join-Path $ProjectRoot "$dir/layers/$($frame.name)/$($layer.name).png"))) {throw "Missing layer: $($yy.name)"}
            }
            if($frame.name -notin $keys.Channels.'0'.Id.name) {throw "Unlinked frame: $($yy.name)"}
            $frames++
        }
    }
    if($yy.resourceType -eq 'GMSound') {
        $file=Join-Path $ProjectRoot "sounds/$($yy.name)/$($yy.soundFile)"
        if(!(Test-Path -LiteralPath $file) -or (Get-Item -LiteralPath $file).Length -lt 44) {throw "Missing audio: $file"}
        $sounds++
    }
}
foreach($zone in @('coast','mines','hades','greece','battlefield','olympus')) {
    $obj=Read-Json "objects/obj_thin_platform_$zone/obj_thin_platform_$zone.yy"
    if($obj.spriteId.name -ne "spr_thin_platform_$zone" -or $obj.spriteMaskId.name -ne 'spr_thin_platform_sea') {throw "Platform mask changed: $zone"}
    $spr=Read-Json "sprites/spr_background_$zone/spr_background_$zone.yy"
    if([Math]::Abs($spr.width/$spr.height-1.5) -gt 0.01) {throw "Wrong panorama crop: $zone"}
    $tiles=Read-Json "sprites/spr_$($zone)_tiles/spr_$($zone)_tiles.yy"
    $image=[Drawing.Bitmap]::new((Join-Path $ProjectRoot "sprites/spr_$($zone)_tiles/$($tiles.frames[0].name).png"))
    try {for($y=0;$y -lt 64;$y+=4) {for($x=0;$x -lt 64;$x+=4) {if($image.GetPixel($x,$y).A -ne 0) {throw "Opaque empty tile: $zone"}}}}
    finally {$image.Dispose()}
}
Write-Output "PASS: $($project.resources.Count) resource graphs, $frames sprite frames/layers/tracks, $sounds audio files, six platform masks and background crops."
