param([string]$ProjectRoot = (Split-Path $PSScriptRoot -Parent))
$ErrorActionPreference='Stop'
$utf8=[Text.UTF8Encoding]::new($false)
function Ref($name) { [pscustomobject]@{name=$name;path="sprites/$name/$name.yy"} }
function Connect($name,$sprite,$mask) {
    $path=Join-Path $ProjectRoot "objects/$name/$name.yy"
    $yy=Get-Content -LiteralPath $path -Raw | ConvertFrom-Json -Depth 100
    $yy.spriteId=Ref $sprite
    $yy.spriteMaskId=Ref $mask
    if($name -eq 'obj_trident_platform'){$yy.visible=$false}
    [IO.File]::WriteAllText($path,($yy|ConvertTo-Json -Depth 100)+"`n",$utf8)
}
foreach($weapon in @('trident','spear','pickaxe','scythe','oar','sword')) {
    Connect "obj_pickup_${weapon}_reward" "spr_weapon_$weapon" 'spr_weapon_collision'
}
Connect 'obj_pickup_olympus_key' 'spr_olympus_key' 'spr_weapon_collision'
Connect 'obj_trident' 'spr_projectile_trident' 'spr_weapon_collision'
Connect 'obj_trident_platform' 'spr_weapon_collision' 'spr_weapon_collision'
Connect 'obj_proj_water_ball' 'spr_projectile_water' 'spr_test_proj'
Connect 'obj_proj_coin' 'spr_projectile_coin' 'spr_test_proj'
Connect 'obj_proj_spear_ghost' 'spr_projectile_ghost_spear' 'spr_test_arrow'
Connect 'obj_proj_fate_beam' 'spr_projectile_fate' 'spr_test_arrow'
Connect 'obj_proj_lightning' 'spr_projectile_lightning' 'spr_test_proj'
Connect 'obj_charon_scythe' 'spr_projectile_scythe' 'spr_test_arrow'
