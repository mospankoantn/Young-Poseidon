$ErrorActionPreference='Stop'
$player=Get-Content -LiteralPath (Join-Path (Split-Path $PSScriptRoot -Parent) 'objects/obj_player/Step_0.gml') -Raw
if($player.Contains('keyboard_check_pressed(ord("1"))')){throw 'Slot 1 still recalls the projectile'}
if(!$player.Contains('if (_f_pressed)')){throw 'Recall no longer uses remappable F action'}
$master=Get-Content -LiteralPath (Join-Path (Split-Path $PSScriptRoot -Parent) 'objects/obj_master/Create_0.gml') -Raw
if(!$master.Contains('global.weapon_unlocked = [false, false, false, false, false, false];')){throw 'Master fallback weapon state differs'}
& (Join-Path $PSScriptRoot 'test_player_death.ps1') -TestPrefix 'world_state' -SuccessMarker 'PASS: WORLD STATE SAVE TESTS'
