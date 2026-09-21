$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot

function Need([string]$path, [string]$pattern, [string]$message) {
    $text = Get-Content -Raw -Encoding UTF8 (Join-Path $root $path)
    if ($text -notmatch $pattern) { throw $message }
}
function MustNot([string]$path, [string]$pattern, [string]$message) {
    $text = Get-Content -Raw -Encoding UTF8 (Join-Path $root $path)
    if ($text -match $pattern) { throw $message }
}

Need 'scripts/scr_cutscene_system/scr_cutscene_system.gml' 'function show_intro_cutscene' 'Intro cutscene helper missing'
Need 'scripts/scr_cutscene_system/scr_cutscene_system.gml' 'function show_outro_cutscene' 'Outro cutscene helper missing'
Need 'scripts/scr_cutscene_system/scr_cutscene_system.gml' 'function show_biome_cutscene' 'Biome cutscene helper missing'
Need 'scripts/scr_cutscene_system/scr_cutscene_system.gml' 'function show_weapon_cutscene' 'Weapon cutscene helper missing'
Need 'scripts/scr_cutscene_system/scr_cutscene_system.gml' 'function yp_trigger_hint' 'Persistent hint helper missing'
Need 'scripts/scr_cutscene_system/scr_cutscene_system.gml' 'instance_create_depth\(0, 0, -10000, obj_cutscene_screen\)' 'Cutscene depth must stay inside GameMaker drawable range'
Need 'scripts/scr_cutscene_system/scr_cutscene_system.gml' 'cutscene_v2_weapon_' 'Fixed weapon cutscene state keys missing'
Need 'objects/obj_cutscene_screen/Step_0.gml' 'vk_space' 'Space cutscene input missing'
Need 'objects/obj_cutscene_screen/Step_0.gml' 'vk_enter' 'Enter cutscene input missing'
Need 'objects/obj_cutscene_screen/Step_0.gml' 'instance_deactivate_object' 'Cutscene-specific gameplay suspension missing'
MustNot 'objects/obj_cutscene_screen/Step_0.gml' 'yp_pause\(true\)' 'Cutscene must not open the pause menu'
Need 'objects/obj_cutscene_screen/Draw_64.gml' 'string_height_ext' 'Responsive cutscene text measurement missing'
Need 'objects/obj_cutscene_screen/Draw_64.gml' 'yp_draw_cursor\(\)' 'Cutscene cursor draw missing'
Need 'scripts/scr_save_system/scr_save_system.gml' 'show_intro_cutscene\(\)' 'New Game does not start intro'
Need 'objects/obj_olympus_door/Step_0.gml' 'show_outro_cutscene\(\)' 'Olympus finale hook missing'
Need 'objects/obj_olympus_door/Step_0.gml' 'yp_input\("F", true\)' 'Olympus door must use interact action F'
Need 'objects/obj_player/Step_0.gml' 'hint_recall_first' 'Throwable recall-first feedback missing'
Need 'objects/obj_player/Step_0.gml' 'global\.cutscene_active' 'Player cutscene lock missing'
MustNot 'objects/obj_pickup_olympus_key/Other_10.gml' 'with \(obj_olympus_door\)' 'Key pickup must not auto-open the final door'

$rewards = @{
    'obj_pickup_trident_reward'='trident';
    'obj_pickup_spear_reward'='spear';
    'obj_pickup_pickaxe_reward'='pickaxe';
    'obj_pickup_scythe_reward'='scythe';
    'obj_pickup_oar_reward'='oar';
    'obj_pickup_sword_reward'='sword';
    'obj_pickup_olympus_key'='key';
}
foreach($pair in $rewards.GetEnumerator()) {
    Need ("objects/{0}/Other_10.gml" -f $pair.Key) ('show_weapon_cutscene\("{0}"\)' -f $pair.Value) ("Reward cutscene missing for {0}" -f $pair.Key)
}

$cutsceneSprites = @('intro','outro','sea','coast','mines','hades','greece','battlefield','olympus','trident','spear','pickaxe','scythe','oar','sword','key')
foreach($name in $cutsceneSprites) {
    $dir = Join-Path $root ("sprites/spr_cutscene_{0}" -f $name)
    if(-not (Test-Path $dir)) { throw "Missing cutscene sprite directory: $name" }
    $yy = Join-Path $dir ("spr_cutscene_{0}.yy" -f $name)
    if(-not (Test-Path $yy)) { throw "Missing cutscene sprite YY: $name" }
}

Write-Host 'Cutscene/tutorial static validation passed.' -ForegroundColor Green
