$ErrorActionPreference='Stop'
$root=Split-Path $PSScriptRoot -Parent
$saveSystem=Get-Content -LiteralPath (Join-Path $root 'scripts/scr_save_system/scr_save_system.gml') -Raw
$playerCreate=Get-Content -LiteralPath (Join-Path $root 'objects/obj_player/Create_0.gml') -Raw
$checkpoint=Get-Content -LiteralPath (Join-Path $root 'objects/obj_checkpoint/Step_0.gml') -Raw
$menu=Get-Content -LiteralPath (Join-Path $root 'scripts/scr_menu_system/scr_menu_system.gml') -Raw
if($playerCreate.Contains('apply_pending_load_to_player();')){throw 'Load is still applied from obj_player Create before UI Create order is guaranteed'}
if(!$saveSystem.Contains('variable_instance_exists(_ui, "show_hint")')){throw 'Save notifications do not guard show_hint initialization'}
if(!$checkpoint.Contains('global.checkpoint_x    = _safe[1];')){throw 'Checkpoint still does not save a validated player position'}
if(!$checkpoint.Contains('autosave_game();')){throw 'Checkpoint no longer writes autosave slot 0'}
if(!$saveSystem.Contains('#macro YP_SAVE_SLOT_MAX 10')){throw 'Ten manual save slots are not configured'}
if(!$saveSystem.Contains('young_poseidon_autosave.ini')){throw 'Autosave slot file is missing'}
if(!$menu.Contains('menu_page="save_slots"') -or !$menu.Contains('menu_page="load_slots"')){throw 'Save/load slot menus are missing'}
if(!$saveSystem.Contains('function save_slot_room(_slot)')){throw 'Save slot room metadata helper is missing'}
if(!$menu.Contains('yp_menu_room_label') -or !$menu.Contains('Рівень: ')){throw 'Save slot menu no longer displays the saved level'}
$bosses=@('triton','nymph','uranus','charon','minotaur','war_ghost','moirai')
foreach($boss in $bosses) {
    $code=Get-Content -LiteralPath (Join-Path $root ("objects/obj_boss_$boss/Step_0.gml")) -Raw
    if(!$code.Contains('autosave_game();')){throw "Boss $boss no longer autosaves the defeated state"}
}
$rewards=@('trident','spear','pickaxe','scythe','oar','sword')
foreach($reward in $rewards) {
    $code=Get-Content -LiteralPath (Join-Path $root ("objects/obj_pickup_${reward}_reward/Other_10.gml")) -Raw
    if(!$code.Contains('autosave_game();')){throw "Reward $reward no longer autosaves after collection"}
}
$keyReward=Get-Content -LiteralPath (Join-Path $root 'objects/obj_pickup_olympus_key/Other_10.gml') -Raw
if(!$keyReward.Contains('autosave_game();')){throw 'Olympus key reward no longer autosaves after collection'}
$player=Get-Content -LiteralPath (Join-Path (Split-Path $PSScriptRoot -Parent) 'objects/obj_player/Step_0.gml') -Raw
if($player.Contains('keyboard_check_pressed(ord("1"))')){throw 'Slot 1 still recalls the projectile'}
if(!$player.Contains('if (_f_pressed)')){throw 'Recall no longer uses remappable F action'}
$master=Get-Content -LiteralPath (Join-Path (Split-Path $PSScriptRoot -Parent) 'objects/obj_master/Create_0.gml') -Raw
if(!$master.Contains('global.weapon_unlocked = [false, false, false, false, false, false];')){throw 'Master fallback weapon state differs'}
& (Join-Path $PSScriptRoot 'test_player_death.ps1') -TestPrefix 'world_state' -SuccessMarker 'PASS: WORLD STATE SAVE TESTS'
