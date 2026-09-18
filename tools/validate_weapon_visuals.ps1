param([string]$ProjectRoot=(Split-Path $PSScriptRoot -Parent))
$ErrorActionPreference='Stop'
Add-Type -AssemblyName System.Drawing
function Read-Json($path) { Get-Content -LiteralPath (Join-Path $ProjectRoot $path) -Raw | ConvertFrom-Json -Depth 100 }
$project=Read-Json 'Young Poseidon.yyp'
$order=Read-Json 'Young Poseidon.resource_order'
$names=@{}
foreach($r in $project.resources) {
    if($names.ContainsKey($r.id.name)){throw "Duplicate resource: $($r.id.name)"}
    $names[$r.id.name]=$r.id.path
    $yy=Read-Json $r.id.path
    if(!$yy.resourceType -or $yy.resourceVersion -ne '2.0'){throw "Format: $($r.id.name)"}
    foreach($ref in @($yy.spriteId,$yy.spriteMaskId,$yy.parentObjectId)) {
        if($null -ne $ref -and !(Test-Path -LiteralPath (Join-Path $ProjectRoot $ref.path))){throw "Missing object reference: $($r.id.name)"}
    }
}
$selected=@($project.resources | Where-Object {$_.id.name -match '^spr_(player_(trident|spear|pickaxe|scythe|oar|sword)_|projectile_|weapon_|olympus_key$)'})
$total=0
foreach($r in $selected) {
    $yy=Read-Json $r.id.path
    $name=$yy.name
    if($yy.resourceType -ne 'GMSprite' -or $yy.'$GMSprite' -ne 'v2'){throw "Sprite format: $name"}
    if($yy.parent.path -notin $project.Folders.folderPath){throw "Folder: $name"}
    if(@($order.ResourceOrderSettings | Where-Object {$_.path -eq $r.id.path}).Count -ne 1){throw "Resource order: $name"}
    $seq=$yy.sequence
    if($seq.resourceType -ne 'GMSequence' -or $seq.resourceVersion -ne '2.0'){throw "Sequence format: $name"}
    if($seq.tracks.Count -ne 1 -or $seq.tracks[0].resourceType -ne 'GMSpriteFramesTrack'){throw "Track: $name"}
    $keys=$seq.tracks[0].keyframes.Keyframes
    if($keys.Count -ne $yy.frames.Count -or $seq.length -ne $yy.frames.Count){throw "Frame count: $name"}
    if($name -like 'spr_player_*' -and ($yy.width -ne 160 -or $yy.height -ne 128 -or $seq.xorigin -ne 80 -or $seq.yorigin -ne 104)){throw "Player anchor: $name"}
    for($i=0;$i -lt $yy.frames.Count;$i++){
        $frame=$yy.frames[$i];$key=$keys[$i]
        if($frame.resourceType -ne 'GMSpriteFrame' -or $frame.resourceVersion -ne '2.0'){throw "Frame format: $name"}
        if($key.Key -ne $i -or $key.Channels.'0'.Id.name -ne $frame.name -or $key.Channels.'0'.Id.path -ne $r.id.path){throw "Frame link: $name"}
        $dir=Join-Path $ProjectRoot "sprites/$name"
        $png=Join-Path $dir ($frame.name+'.png')
        $layer=Join-Path $dir ("layers/"+$frame.name+"/"+$yy.layers[0].name+".png")
        if((Get-FileHash -LiteralPath $png).Hash -ne (Get-FileHash -LiteralPath $layer).Hash){throw "Layer mismatch: $name"}
        $im=[Drawing.Bitmap]::new($png)
        try {
            if($im.Width -ne $yy.width -or $im.Height -ne $yy.height){throw "PNG size: $name"}
            $visible=0
            for($y=0;$y -lt $im.Height;$y++){for($x=0;$x -lt $im.Width;$x++){if($im.GetPixel($x,$y).A -gt 64){$visible++}}}
            if($visible -lt 10){throw "Empty frame: $name"}
            if($name -like 'spr_player_*'){
                for($x=0;$x -lt $im.Width;$x++){if($im.GetPixel($x,0).A -gt 64 -or $im.GetPixel($x,$im.Height-1).A -gt 64){throw "Vertical clipping: $name/$i"}}
                for($y=0;$y -lt $im.Height;$y++){if($im.GetPixel(0,$y).A -gt 64 -or $im.GetPixel($im.Width-1,$y).A -gt 64){throw "Horizontal clipping: $name/$i"}}
            }
        }finally{$im.Dispose()}
        $total++
    }
}
$manifest=Read-Json 'tools/weapon_visuals_manifest.json'
if($manifest.Count -ne 6 -or @($manifest.source|Select-Object -Unique).Count -ne 6){throw 'Missing or duplicate source sheet'}
foreach($item in $manifest){
    if(!(Test-Path -LiteralPath (Join-Path $ProjectRoot ('Файли/'+$item.source)))){throw 'Source missing'}
    $obj=Read-Json "objects/obj_pickup_$($item.weapon)_reward/obj_pickup_$($item.weapon)_reward.yy"
    if($obj.spriteId.name -ne "spr_weapon_$($item.weapon)" -or $obj.spriteMaskId.name -ne 'spr_weapon_collision'){throw 'Reward mapping'}
}
Write-Output "PASS: six source sheets, $($selected.Count) sprites, $total frames; formats, registrations, object references, tracks, layers, transparency and frame borders."
