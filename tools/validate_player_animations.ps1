param([string]$ProjectRoot=(Split-Path $PSScriptRoot -Parent))
$ErrorActionPreference='Stop'
Add-Type -AssemblyName System.Drawing
$project=Get-Content -LiteralPath (Join-Path $ProjectRoot 'Young Poseidon.yyp') -Raw -Encoding utf8 | ConvertFrom-Json -Depth 100
if($project.resourceType -ne 'GMProject' -or $project.resourceVersion -ne '2.0') {throw 'Invalid project type/version'}
$names=@{}
$paths=@{}
foreach($resource in $project.resources) {
    $id=$resource.id
    if($names.ContainsKey($id.name) -or $paths.ContainsKey($id.path)) {throw "Duplicate resource: $($id.name)"}
    $names[$id.name]=$true
    $paths[$id.path]=$true
    $path=Join-Path $ProjectRoot $id.path
    $yy=Get-Content -LiteralPath $path -Raw -Encoding utf8 | ConvertFrom-Json -Depth 100
    if($yy.name -ne $id.name -or !$yy.resourceType -or $yy.resourceVersion -ne '2.0') {throw "Invalid resource: $path"}
    if($yy.parent -and $yy.parent.path -notin $project.Folders.folderPath) {throw "Unknown parent folder: $path"}
}
$parsed=0
foreach($dir in @('objects','sprites','scripts','rooms','sounds','fonts','tilesets','options')) {
    foreach($file in Get-ChildItem -LiteralPath (Join-Path $ProjectRoot $dir) -Filter '*.yy' -Recurse) {
        $null=Get-Content -LiteralPath $file.FullName -Raw -Encoding utf8 | ConvertFrom-Json -Depth 100
        $parsed++
    }
}
$frameTotal=0
foreach($state in @('idle','run','jump','land','attack','hurt')) {
    $name='spr_player_'+$state
    if(!$names.ContainsKey($name)) {throw "Unregistered sprite: $name"}
    $dir=Join-Path $ProjectRoot "sprites/$name"
    $yy=Get-Content -LiteralPath (Join-Path $dir "$name.yy") -Raw -Encoding utf8 | ConvertFrom-Json -Depth 100
    if($yy.resourceType -ne 'GMSprite' -or $yy.'$GMSprite' -ne 'v2') {throw "Wrong sprite schema: $name"}
    if($yy.width -ne 128 -or $yy.height -ne 96 -or $yy.sequence.xorigin -ne 64 -or $yy.sequence.yorigin -ne 88) {throw "Misaligned sprite: $name"}
    $seq=$yy.sequence
    if($seq.resourceType -ne 'GMSequence' -or $seq.resourceVersion -ne '2.0' -or $seq.playbackSpeedType -ne 0 -or $seq.playbackSpeed -le 0) {throw "Invalid sequence: $name"}
    $keys=$seq.tracks[0].keyframes.Keyframes
    if($seq.length -ne $yy.frames.Count -or $keys.Count -ne $yy.frames.Count) {throw "Frame count mismatch: $name"}
    for($i=0;$i -lt $yy.frames.Count;$i++) {
        $frame=$yy.frames[$i]
        $key=$keys[$i]
        if($frame.resourceType -ne 'GMSpriteFrame' -or $frame.resourceVersion -ne '2.0') {throw "Wrong frame type: $name"}
        if($key.Key -ne $i -or $key.Channels.'0'.Id.name -ne $frame.name -or $key.Channels.'0'.Id.path -ne "sprites/$name/$name.yy") {throw "Broken frame link: $name frame $i"}
        $png=Join-Path $dir ($frame.name+'.png')
        $layer=Join-Path $dir ('layers/'+$frame.name+'/'+$yy.layers[0].name+'.png')
        if((Get-FileHash -LiteralPath $png).Hash -ne (Get-FileHash -LiteralPath $layer).Hash) {throw "Layer/composite mismatch: $name frame $i"}
        $bitmap=[System.Drawing.Bitmap]::new($png)
        $visible=0
        for($y=0;$y -lt $bitmap.Height;$y++) {
            for($x=0;$x -lt $bitmap.Width;$x++) {
                if($bitmap.GetPixel($x,$y).A -gt 0) {$visible++}
            }
        }
        if($bitmap.Width -ne 128 -or $bitmap.Height -ne 96 -or $visible -lt 100 -or $visible -gt 6000) {throw "Invalid/empty frame: $name frame $i"}
        foreach($corner in @(@(0,0),@(127,0),@(0,95),@(127,95))) {
            if($bitmap.GetPixel($corner[0],$corner[1]).A -ne 0) {throw "Opaque frame border: $name"}
        }
        $bitmap.Dispose()
        $frameTotal++
    }
}
$player=Get-Content -LiteralPath (Join-Path $ProjectRoot 'objects/obj_player/obj_player.yy') -Raw | ConvertFrom-Json -Depth 100
$endStep=@($player.eventList | Where-Object {$_.eventType -eq 3 -and $_.eventNum -eq 2})
if($endStep.Count -ne 1 -or !(Test-Path (Join-Path $ProjectRoot 'objects/obj_player/Step_2.gml'))) {throw 'Missing/duplicate End Step event'}
$create=Get-Content -LiteralPath (Join-Path $ProjectRoot 'objects/obj_player/Create_0.gml') -Raw
if(!$create.Contains('mask_index = spr_player;')) {throw 'The original collision mask is not preserved'}
Write-Output "PASS: $parsed YY files parse; $($project.resources.Count) unique project resources link."
Write-Output "PASS: 6 gameplay sprites, $frameTotal nonempty transparent frames, origins, layers, timing and End Step registration."

