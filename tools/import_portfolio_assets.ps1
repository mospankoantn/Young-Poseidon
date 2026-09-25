param([string]$ProjectRoot=(Split-Path $PSScriptRoot -Parent))
$ErrorActionPreference='Stop'
Add-Type -AssemblyName System.Drawing
$utf8=[Text.UTF8Encoding]::new($false)
function Read-Json($p) { Get-Content -LiteralPath (Join-Path $ProjectRoot $p) -Raw | ConvertFrom-Json -Depth 100 }
function Save-Json($p,$v) { [IO.File]::WriteAllText((Join-Path $ProjectRoot $p),($v | ConvertTo-Json -Depth 100)+"`n",$utf8) }
function Clone($v) { $v | ConvertTo-Json -Depth 100 | ConvertFrom-Json -Depth 100 }
$project=Read-Json 'Young Poseidon.yyp'
$order=Read-Json 'Young Poseidon.resource_order'
function Register($name,$path) {
    if(!@($project.resources | Where-Object {$_.id.name -eq $name}).Count) { $project.resources += [pscustomobject]@{id=[pscustomobject]@{name=$name;path=$path}} }
    if(!@($order.ResourceOrderSettings | Where-Object name -eq $name).Count) { $order.ResourceOrderSettings += [pscustomobject]@{name=$name;path=$path;order=$order.ResourceOrderSettings.Count} }
}
function Scale-Image($source,$w,$h) {
    $b=[Drawing.Bitmap]::new($w,$h,[Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g=[Drawing.Graphics]::FromImage($b)
    $g.InterpolationMode=[Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
    $g.PixelOffsetMode=[Drawing.Drawing2D.PixelOffsetMode]::Half
    $g.DrawImage($source,[Drawing.Rectangle]::new(0,0,$w,$h))
    $g.Dispose()
    return ,$b
}
function Save-Sprite($name,$bitmap,$template='spr_cutscene_intro') {
    $relative="sprites/$name/$name.yy"
    $dir=Join-Path $ProjectRoot "sprites/$name"
    [IO.Directory]::CreateDirectory($dir) | Out-Null
    if(Test-Path (Join-Path $ProjectRoot $relative)) { $spr=Read-Json $relative }
    else {
        $spr=Clone (Read-Json "sprites/$template/$template.yy")
        $spr.name=$name;$spr.'%Name'=$name;$spr.sequence.name=$name;$spr.sequence.'%Name'=$name
        $spr.frames=@($spr.frames[0]);$spr.sequence.length=1
        $spr.sequence.tracks[0].keyframes.Keyframes=@($spr.sequence.tracks[0].keyframes.Keyframes[0])
        $frame=[guid]::NewGuid().ToString();$layer=[guid]::NewGuid().ToString()
        $spr.frames[0].name=$frame;$spr.frames[0].'%Name'=$frame
        $spr.layers[0].name=$layer;$spr.layers[0].'%Name'=$layer
        $key=$spr.sequence.tracks[0].keyframes.Keyframes[0]
        $key.id=[guid]::NewGuid().ToString();$key.Key=0;$key.Length=1
        $key.Channels.'0'.Id.name=$frame;$key.Channels.'0'.Id.path=$relative
    }
    $spr.width=$bitmap.Width;$spr.height=$bitmap.Height
    $spr.bbox_bottom=$bitmap.Height-1;$spr.bbox_right=$bitmap.Width-1
    $frame=$spr.frames[0].name;$layer=$spr.layers[0].name
    $layers=Join-Path $dir "layers/$frame"
    [IO.Directory]::CreateDirectory($layers) | Out-Null
    $bitmap.Save((Join-Path $dir "$frame.png"),[Drawing.Imaging.ImageFormat]::Png)
    $bitmap.Save((Join-Path $layers "$layer.png"),[Drawing.Imaging.ImageFormat]::Png)
    Save-Json $relative $spr
    Register $name $relative
}
$manifest=Read-Json 'tools/portfolio_art_manifest.json'
foreach($asset in $manifest) {
    $source=Join-Path $ProjectRoot $asset.local
    if(!(Test-Path $source)) {
        [IO.Directory]::CreateDirectory((Split-Path $source -Parent)) | Out-Null
        Copy-Item -LiteralPath $asset.generated -Destination $source
    }
    $inputImage=[Drawing.Bitmap]::new($source)
    try {
        if($asset.kind -eq 'scene') {
            $image=Scale-Image $inputImage 960 540
            try { Save-Sprite "spr_cutscene_$($asset.name)" $image } finally { $image.Dispose() }
        }
        elseif($asset.kind -eq 'logo') {
            $image=Scale-Image $inputImage 720 240
            try {
                Save-Sprite 'spr_logo_eclipse_wire' $image
                $spr=Read-Json 'sprites/spr_logo_eclipse_wire/spr_logo_eclipse_wire.yy'
                $spr.origin=4;$spr.sequence.xorigin=360;$spr.sequence.yorigin=120
                Save-Json 'sprites/spr_logo_eclipse_wire/spr_logo_eclipse_wire.yy' $spr
            } finally { $image.Dispose() }
        }
        elseif($asset.kind -eq 'terrain') {
            $atlas=Scale-Image $inputImage 512 512
            try {
                # Index zero is empty. Ground remains indices 8..15; room tilemaps are untouched.
                for($y=0;$y -lt 64;$y++) { for($x=0;$x -lt 64;$x++) {$atlas.SetPixel($x,$y,[Drawing.Color]::Transparent)} }
                Save-Sprite "spr_$($asset.name)_tiles" $atlas
                $preview=[Drawing.Bitmap]::new(544,544)
                try {
                    for($i=1;$i -lt 64;$i++) {
                        $cx=$i%8;$cy=[int][Math]::Floor($i/8)
                        for($py=0;$py -lt 68;$py++) {for($px=0;$px -lt 68;$px++) {
                            $sx=$cx*64+[Math]::Clamp($px-2,0,63);$sy=$cy*64+[Math]::Clamp($py-2,0,63)
                            $preview.SetPixel($cx*68+$px,$cy*68+$py,$atlas.GetPixel($sx,$sy))
                        }}
                    }
                    $preview.Save((Join-Path $ProjectRoot "tilesets/ts_$($asset.name)/output_tileset.png"),[Drawing.Imaging.ImageFormat]::Png)
                } finally { $preview.Dispose() }
                $thin=[Drawing.Bitmap]::new(164,24,[Drawing.Imaging.PixelFormat]::Format32bppArgb)
                try {
                    for($py=0;$py -lt 24;$py++) {for($px=0;$px -lt 164;$px++) {
                        if($py -lt 19 -or ($px%13) -gt 2) { $thin.SetPixel($px,$py,$atlas.GetPixel(($px+64)%512,64+$py)) }
                    }}
                    Save-Sprite "spr_thin_platform_$($asset.name)" $thin 'spr_thin_platform_sea'
                } finally { $thin.Dispose() }
                $objPath="objects/obj_thin_platform_$($asset.name)/obj_thin_platform_$($asset.name).yy"
                $obj=Read-Json $objPath
                $obj.spriteId=[pscustomobject]@{name="spr_thin_platform_$($asset.name)";path="sprites/spr_thin_platform_$($asset.name)/spr_thin_platform_$($asset.name).yy"}
                $obj.spriteMaskId=[pscustomobject]@{name='spr_thin_platform_sea';path='sprites/spr_thin_platform_sea/spr_thin_platform_sea.yy'}
                Save-Json $objPath $obj
            } finally { $atlas.Dispose() }
        }
    } finally { $inputImage.Dispose() }
}
$soundTemplate=Read-Json 'sounds/snd_jump/snd_jump.yy'
foreach($dir in Get-ChildItem (Join-Path $ProjectRoot 'sounds') -Directory | Where-Object {$_.Name -like 'snd_zone_*' -or $_.Name -like 'snd_fx_*'}) {
    $name=$dir.Name;$relative="sounds/$name/$name.yy"
    $sound=Clone $soundTemplate
    $sound.name=$name;$sound.'%Name'=$name;$sound.soundFile="$name.wav"
    $sound.volume=1;$sound.sampleRate=22050;$sound.channelFormat=1
    $sound.duration=([IO.FileInfo](Join-Path $dir.FullName "$name.wav")).Length/88200
    Save-Json $relative $sound;Register $name $relative
}
# Reuse this project's GMEvent and GMObject schema for the small decoration hierarchy.
$enemy=Read-Json 'objects/obj_enemy/obj_enemy.yy'
$eventTemplate=(Read-Json 'objects/obj_player/obj_player.yy').eventList[0]
function Event($type,$number) {
    $e=Clone $eventTemplate;$e.eventType=$type;$e.eventNum=$number;$e.collisionObjectId=$null
    return $e
}
if(!@($enemy.eventList | Where-Object {$_.eventType -eq 8 -and $_.eventNum -eq 0}).Count) {
    $enemy.eventList += Event 8 0
    Save-Json 'objects/obj_enemy/obj_enemy.yy' $enemy
}
foreach($zone in @('base','coast','mines','hades','greece','battlefield','olympus')) {
    $name="obj_decor_$zone";$relative="objects/$name/$name.yy"
    $obj=Clone $enemy;$obj.name=$name;$obj.'%Name'=$name;$obj.eventList=@()
    $obj.parent=(Read-Json 'objects/obj_bubble/obj_bubble.yy').parent
    if($zone -eq 'base') {$obj.eventList=@((Event 0 0),(Event 3 0),(Event 8 0))}
    else {$obj.parentObjectId=[pscustomobject]@{name='obj_decor_base';path='objects/obj_decor_base/obj_decor_base.yy'}}
    [IO.Directory]::CreateDirectory((Join-Path $ProjectRoot "objects/$name")) | Out-Null
    Save-Json $relative $obj;Register $name $relative
}
Save-Json 'Young Poseidon.yyp' $project
Save-Json 'Young Poseidon.resource_order' $order
Write-Output "Imported $($manifest.Count) art sources, six platform sprites, 25 sounds and seven decoration objects."
