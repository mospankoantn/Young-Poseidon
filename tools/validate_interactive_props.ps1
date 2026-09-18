param([string]$ProjectRoot=(Split-Path $PSScriptRoot -Parent))
$ErrorActionPreference='Stop'
Add-Type -AssemblyName System.Drawing
function ReadJ($path){Get-Content -LiteralPath (Join-Path $ProjectRoot $path) -Raw | ConvertFrom-Json -Depth 100}
$project=ReadJ 'Young Poseidon.yyp'
$paths=@($project.resources.id.path)
function CheckNodes($value){
    if($null -eq $value){return}
    if($value -is [pscustomobject]){
        if($value.resourceType -and $value.resourceVersion -ne '2.0'){throw "Missing/wrong version: $($value.resourceType)"}
        if($value.path -match '^(sprites|objects|scripts)/'){
            if($value.path -notin $paths -or !(Test-Path -LiteralPath (Join-Path $ProjectRoot $value.path))){throw "Missing reference: $($value.path)"}
        }
        foreach($prop in $value.PSObject.Properties){CheckNodes $prop.Value}
    } elseif($value -is [array]){foreach($item in $value){CheckNodes $item}}
}
$frames=0
$props=@('falling_rocks','falling_stone','interactive_button','mine_cart','minotaur_column','olympus_door','raft','rail','stalactite','stone_boulder','thicket_platform','uranus_barrier','checkpoint')
foreach($prop in $props){
    $name="spr_$prop";$path="sprites/$name/$name.yy";$s=ReadJ $path
    if($path -notin $paths -or $s.resourceType -ne 'GMSprite' -or $s.'$GMSprite' -ne 'v2'){throw "Invalid sprite: $name"}
    CheckNodes $s
    if($s.parent.path -notin $project.Folders.folderPath){throw "Missing folder: $name"}
    $keys=$s.sequence.tracks[0].keyframes.Keyframes
    if($s.sequence.length -ne $s.frames.Count -or $keys.Count -ne $s.frames.Count){throw "Invalid sequence: $name"}
    for($i=0;$i -lt $s.frames.Count;$i++){
        $f=$s.frames[$i];$key=$keys[$i]
        if($key.Key -ne $i -or $key.Channels.'0'.Id.name -ne $f.name -or $key.Channels.'0'.Id.path -ne $path){throw "Broken frame: $name/$i"}
        $png=Join-Path $ProjectRoot "sprites/$name/$($f.name).png"
        $layer=Join-Path $ProjectRoot "sprites/$name/layers/$($f.name)/$($s.layers[0].name).png"
        if((Get-FileHash -LiteralPath $png).Hash -ne (Get-FileHash -LiteralPath $layer).Hash){throw "Layer mismatch: $name"}
        $b=[Drawing.Bitmap]::new($png);$visible=0
        try{
            if($b.Width -ne $s.width -or $b.Height -ne $s.height){throw "Wrong frame dimensions: $name"}
            for($y=0;$y -lt $b.Height;$y++){for($x=0;$x -lt $b.Width;$x++){
                $c=$b.GetPixel($x,$y)
                if($c.A -gt 0){
                    $visible++
                    if($x -eq 0 -or $y -eq 0 -or $x -eq $b.Width-1 -or $y -eq $b.Height-1){throw "Opaque border: $name"}
                    if($c.R -gt 100 -and $c.B -gt 100 -and $c.G -lt [Math]::Min($c.R,$c.B)*0.65){throw "Unkeyed magenta: $name"}
                }
            }}
            if($visible -lt 50 -or $visible -ge $b.Width*$b.Height){throw "Empty/opaque frame: $name"}
        }finally{$b.Dispose()}
        $frames++
    }
    $o=ReadJ "objects/obj_$prop/obj_$prop.yy"
    CheckNodes $o
    if($o.spriteId.path -ne $path){throw "Wrong object sprite: $prop"}
    if($prop -in @('falling_rocks','falling_stone') -and $null -ne $o.parentObjectId){throw 'Falling debris must not inherit platform collision'}
    if($prop -notin @('falling_rocks','falling_stone') -and !$o.spriteMaskId){throw "Lost legacy mask: $prop"}
}
CheckNodes (ReadJ 'scripts/scr_interactive_props/scr_interactive_props.yy')
foreach($o in Get-ChildItem -LiteralPath (Join-Path $ProjectRoot 'objects') -Filter '*.yy' -Recurse){CheckNodes (ReadJ ([IO.Path]::GetRelativePath($ProjectRoot,$o.FullName)))}
Write-Output "PASS: 13 interactive sprites, $frames transparent frames, layers, sequences, schema versions and all object references."

