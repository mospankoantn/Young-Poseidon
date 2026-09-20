param([string]$ProjectRoot=(Split-Path $PSScriptRoot -Parent))
$ErrorActionPreference='Stop'
Add-Type -AssemblyName System.Drawing
$project=Get-Content -LiteralPath (Join-Path $ProjectRoot 'Young Poseidon.yyp') -Raw | ConvertFrom-Json -Depth 100
$order=Get-Content -LiteralPath (Join-Path $ProjectRoot 'Young Poseidon.resource_order') -Raw | ConvertFrom-Json -Depth 100
if($project.resourceType -ne 'GMProject' -or $project.resourceVersion -ne '2.0') {throw 'Project format mismatch'}
$resourceMap=@{}
foreach($r in $project.resources) {
    if($resourceMap.ContainsKey($r.id.name)) {throw "Duplicate project name: $($r.id.name)"}
    $resourceMap[$r.id.name]=$r.id.path
    if(!(Test-Path -LiteralPath (Join-Path $ProjectRoot $r.id.path))) {throw "Missing project resource: $($r.id.path)"}
}
$orderMap=@{}
foreach($r in $order.ResourceOrderSettings) {
    if($orderMap.ContainsKey($r.name)) {throw "Duplicate resource order: $($r.name)"}
    if($r.order -isnot [int] -and $r.order -isnot [long]) {throw "Non-integer resource order: $($r.name)"}
    $orderMap[$r.name]=$r.path
    if(!(Test-Path -LiteralPath (Join-Path $ProjectRoot $r.path))) {throw "Missing resource-order path: $($r.path)"}
}
$items=@(
    @('giant_crab','Графіка/Вороги/Спрайти Краба.png'),@('harpy_seagull','Графіка/Вороги/Sprites obj_harpy_seagull.png'),
    @('miner_spirit','Графіка/Вороги/Sprites obj_miner_spirit.png'),@('hades_shadow','Графіка/Вороги/Sprites obj_hades_shadow.png'),
    @('greek_warrior','Графіка/Вороги/Sprites obj_greek_warrior.png'),@('fallen_spirit','Графіка/Вороги/Sprites obj_fallen_spirit.png'),
    @('olympus_fire','Графіка/Вороги/Sprites obj_olympus_fire.png'),@('boss_triton','Графіка/Боси/Sprites obj_boss_triton.png'),
    @('boss_nymph','Графіка/Боси/Sprites obj_boss_nymph.png'),@('boss_uranus','Графіка/Боси/Sprites obj_boss_uranus.png'),
    @('boss_charon','Графіка/Боси/Sprites obj_boss_charon.png'),@('boss_minotaur','Графіка/Боси/Sprites obj_boss_minotaur.png'),
    @('boss_war_ghost','Графіка/Боси/Sprites obj_boss_war_ghost.png'),@('boss_moirai','Графіка/Боси/Sprites obj_boss_moirai.png')
)
$seenSources=@{}
$totalFrames=0
foreach($item in $items) {
    $n=$item[0]; $source=$item[1]
    if($seenSources.ContainsKey($source)) {throw "Duplicated source mapping: $source"}
    $seenSources[$source]=$true
    if(!(Test-Path -LiteralPath (Join-Path $ProjectRoot ('Файли/'+$source)))) {throw "Missing source PNG: $source"}
    $objectName='obj_'+$n
    $object=Get-Content -LiteralPath (Join-Path $ProjectRoot ("objects/$objectName/$objectName.yy")) -Raw | ConvertFrom-Json -Depth 100
    $idle='spr_'+$n+'_idle'
    if($object.resourceType -ne 'GMObject' -or $object.resourceVersion -ne '2.0') {throw "Wrong object schema: $objectName"}
    if($object.spriteId.name -ne $idle -or $object.spriteId.path -ne "sprites/$idle/$idle.yy") {throw "Wrong idle sprite: $objectName"}
    $expectedMask=if($n -eq 'giant_crab'){'spr_giant_crab_mask'}else{'spr_giant_crab'}
    $expectedMaskPath="sprites/$expectedMask/$expectedMask.yy"
    if($object.spriteMaskId.name -ne $expectedMask -or $object.spriteMaskId.path -ne $expectedMaskPath) {throw "Collision mask changed: $objectName"}
    $endSteps=@($object.eventList | Where-Object {$_.eventType -eq 3 -and $_.eventNum -eq 2})
    if($endSteps.Count -ne 1 -or !(Test-Path -LiteralPath (Join-Path $ProjectRoot ("objects/$objectName/Step_2.gml")))) {throw "End Step missing: $objectName"}
    foreach($state in @('idle','move','attack','death')) {
        $name='spr_'+$n+'_'+$state
        $relative="sprites/$name/$name.yy"
        if($resourceMap[$name] -ne $relative -or $orderMap[$name] -ne $relative) {throw "Project registration mismatch: $name"}
        $dir=Join-Path $ProjectRoot ('sprites/'+$name)
        $yy=Get-Content -LiteralPath (Join-Path $dir ($name+'.yy')) -Raw | ConvertFrom-Json -Depth 100
        $size=if($n.StartsWith('boss_')){192}else{96}
        if($yy.name -ne $name -or $yy.resourceType -ne 'GMSprite' -or $yy.resourceVersion -ne '2.0' -or $yy.'$GMSprite' -ne 'v2') {throw "Wrong sprite schema: $name"}
        if($yy.width -ne $size -or $yy.height -ne $size -or $yy.sequence.xorigin -ne $size/2 -or $yy.sequence.yorigin -ne $size-6) {throw "Wrong dimensions/origin: $name"}
        if($yy.parent.path -notin $project.Folders.folderPath) {throw "Unknown sprite folder: $name"}
        if($yy.sequence.resourceType -ne 'GMSequence' -or $yy.sequence.resourceVersion -ne '2.0' -or $yy.sequence.playbackSpeedType -ne 0) {throw "Wrong sequence: $name"}
        if($yy.frames.Count -ne 4 -or $yy.sequence.length -ne 4 -or $yy.sequence.tracks.Count -ne 1) {throw "Wrong frame count: $name"}
        $keys=@($yy.sequence.tracks[0].keyframes.Keyframes)
        if($keys.Count -ne 4 -or $yy.sequence.tracks[0].resourceType -ne 'GMSpriteFramesTrack') {throw "Wrong frame track: $name"}
        $frameIds=@{}
        for($i=0;$i -lt 4;$i++) {
            $frame=$yy.frames[$i]; $key=$keys[$i]
            if($frameIds.ContainsKey($frame.name)) {throw "Repeated frame id: $name"}
            $frameIds[$frame.name]=$true
            if($frame.resourceType -ne 'GMSpriteFrame' -or $frame.resourceVersion -ne '2.0') {throw "Wrong frame schema: $name"}
            if($key.Key -ne $i -or $key.Channels.'0'.Id.name -ne $frame.name -or $key.Channels.'0'.Id.path -ne $relative) {throw "Broken keyframe: $name/$i"}
            $png=Join-Path $dir ($frame.name+'.png')
            $layer=Join-Path $dir ('layers/'+$frame.name+'/'+$yy.layers[0].name+'.png')
            if(!(Test-Path -LiteralPath $png) -or !(Test-Path -LiteralPath $layer)) {throw "Missing PNG: $name/$i"}
            if((Get-FileHash -LiteralPath $png).Hash -ne (Get-FileHash -LiteralPath $layer).Hash) {throw "Layer mismatch: $name/$i"}
            $im=[Drawing.Bitmap]::new($png)
            try {
                if($im.Width -ne $size -or $im.Height -ne $size) {throw "PNG size mismatch: $name/$i"}
                $visible=0
                for($y=0;$y -lt $size;$y+=3){for($x=0;$x -lt $size;$x+=3){if($im.GetPixel($x,$y).A -gt 16){$visible++}}}
                if($visible -lt 10) {throw "Empty PNG: $name/$i"}
                foreach($pt in @(@(0,0),@(($size-1),0),@(0,($size-1)),@(($size-1),($size-1)))) {
                    if($im.GetPixel($pt[0],$pt[1]).A -gt 0) {throw "Clipped border: $name/$i"}
                }
            } finally {$im.Dispose()}
            $totalFrames++
        }
    }
}
$crabMaskName='spr_giant_crab_mask'
$crabMaskPath="sprites/$crabMaskName/$crabMaskName.yy"
if($resourceMap[$crabMaskName] -ne $crabMaskPath -or $orderMap[$crabMaskName] -ne $crabMaskPath) {throw 'Crab mask is not registered'}
$crabMask=Get-Content -LiteralPath (Join-Path $ProjectRoot $crabMaskPath) -Raw | ConvertFrom-Json -Depth 100
if($crabMask.width -ne 96 -or $crabMask.height -ne 96 -or $crabMask.sequence.xorigin -ne 48 -or $crabMask.sequence.yorigin -ne 90) {throw 'Crab mask dimensions/origin mismatch'}
if($crabMask.bbox_left -ne 12 -or $crabMask.bbox_right -ne 84 -or $crabMask.bbox_top -ne 48 -or $crabMask.bbox_bottom -ne 90) {throw 'Crab hitbox bounds mismatch'}

$crabMaskFrame=$crabMask.frames[0].name
$crabMaskLayer=$crabMask.layers[0].name
$crabMaskDir=Join-Path $ProjectRoot 'sprites/spr_giant_crab_mask'
if(!(Test-Path -LiteralPath (Join-Path $crabMaskDir ($crabMaskFrame+'.png'))) -or
   !(Test-Path -LiteralPath (Join-Path $crabMaskDir ("layers/"+$crabMaskFrame+"/"+$crabMaskLayer+".png")))) {
    throw 'Crab mask frame/layer PNG missing'
}

$crabStep=Get-Content -LiteralPath (Join-Path $ProjectRoot 'objects/obj_giant_crab/Step_0.gml') -Raw
if($crabStep -notmatch 'place_meeting\(_next_x, y - 2, obj_platform\)' -or $crabStep -notmatch 'x = _next_x') {throw 'Crab patrol wall probe can regress into floor jitter'}
if($resourceMap['scr_enemy_animation'] -ne 'scripts/scr_enemy_animation/scr_enemy_animation.yy') {throw 'Animation script not registered'}
if($totalFrames -ne 224) {throw "Unexpected total: $totalFrames"}

# Nymph arrow direction/damage contract.
$nymphStep=Get-Content -LiteralPath (Join-Path $ProjectRoot 'objects/obj_boss_nymph/Step_0.gml') -Raw
$arrowCreate=Get-Content -LiteralPath (Join-Path $ProjectRoot 'objects/obj_arrow/Create_0.gml') -Raw
$arrowStep=Get-Content -LiteralPath (Join-Path $ProjectRoot 'objects/obj_arrow/Step_0.gml') -Raw
if($arrowCreate -notmatch 'direction_y\s*=\s*0') {throw 'obj_arrow direction_y default missing'}
if($nymphStep -notmatch '_arr\.direction_x\s*=\s*0' -or $nymphStep -notmatch '_arr\.direction_y\s*=\s*1' -or $nymphStep -notmatch '_arr\.damage\s*=\s*atk') {throw 'Nymph arrow direction/damage contract missing'}
if($arrowStep -notmatch 'point_distance\(0, 0, _dx, _dy\)' -or $arrowStep -notmatch '_p\.hp\s*-=\s*damage') {throw 'obj_arrow 2D movement or player damage missing'}

Write-Output "PASS: 224 transparent frames, YY/YYP links, sequence tracks, collision masks and End Step events."
