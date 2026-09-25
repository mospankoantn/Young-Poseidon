$ErrorActionPreference='Stop'
$root=Split-Path $PSScriptRoot -Parent
$utf8=[Text.UTF8Encoding]::new($false)
$actors=@('giant_crab','harpy_seagull','miner_spirit','hades_shadow','greek_warrior','fallen_spirit','olympus_fire','boss_triton','boss_nymph','boss_uranus','boss_charon','boss_minotaur','boss_war_ghost','boss_moirai')
foreach($actor in $actors) {
    $dir=Join-Path $root "objects/obj_$actor"
    $create=Join-Path $dir 'Create_0.gml'
    $code=[IO.File]::ReadAllText($create)
    if(!$code.Contains('enemy_combat_init();')) { [IO.File]::WriteAllText($create,$code.TrimEnd()+"`n`nenemy_combat_init();`n",$utf8) }
    $step=Join-Path $dir 'Step_0.gml'
    $code=[IO.File]::ReadAllText($step)
    if(!$code.Contains('enemy_combat_tick()')) { $code="if (enemy_combat_tick()) exit;`n"+$code }
    $code=$code.Replace('!obj_player.is_damage','!obj_player.is_damage && enemy_can_damage(id)')
    $code=$code.Replace('&& enemy_can_damage(id) && enemy_can_damage(id)','&& enemy_can_damage(id)')
    [IO.File]::WriteAllText($step,$code,$utf8)
    $draw=Join-Path $dir 'Draw_0.gml'
    if(Test-Path $draw) {
        $code=[IO.File]::ReadAllText($draw).Replace('draw_self();','enemy_draw_body();')
        [IO.File]::WriteAllText($draw,$code,$utf8)
    }
}
Write-Output 'Connected combat feedback and damage guards for 14 actors.'

foreach($file in Get-ChildItem (Join-Path $root 'objects') -Filter 'Draw_73.gml' -Recurse | Where-Object {$_.Directory.Name -like '*filter'}) {
    $code=[IO.File]::ReadAllText($file.FullName)
    if(!$code.Contains('yp_fx_alpha(')) {
        $code=[regex]::Replace($code,'draw_set_alpha\(([^;]+)\);',{
            param($m)
            if($m.Groups[1].Value -in @('0','1')) {return $m.Value}
            return 'draw_set_alpha(yp_fx_alpha('+$m.Groups[1].Value+'));'
        })
        $code="if (view_camera[0] == -1) exit;`n"+$code
        [IO.File]::WriteAllText($file.FullName,$code,$utf8)
    }
}
# Sound hooks run only when an actual pickup/action succeeded.
foreach($file in Get-ChildItem (Join-Path $root 'objects') -Filter '*.gml' -Recurse | Where-Object {$_.Directory.Name -like 'obj_pickup_*'}) {
    $code=[IO.File]::ReadAllText($file.FullName)
    if($code.Contains('world_state_mark_instance(id, "pickup");') -and !$code.Contains('yp_sfx(')) {
        $sound=if($file.Directory.Name -like '*reward' -or $file.Directory.Name -eq 'obj_pickup_olympus_key') {'reward'} else {'pickup'}
        $code=$code.Replace('world_state_mark_instance(id, "pickup");',('world_state_mark_instance(id, "pickup");' + "`nyp_sfx(`"$sound`", x);"))
        [IO.File]::WriteAllText($file.FullName,$code,$utf8)
    }
}
foreach($name in @('obj_proj_water_ball','obj_proj_spear_ghost','obj_proj_lightning','obj_proj_fate_beam','obj_proj_coin','obj_falling_rocks')) {
    $path=Join-Path $root "objects/$name/Step_0.gml"
    $code=[IO.File]::ReadAllText($path)
    if(!$code.Contains('!obj_player.is_dead')) {$code=$code.Replace('!obj_player.is_damage','!obj_player.is_damage && !obj_player.is_dead')}
    [IO.File]::WriteAllText($path,$code,$utf8)
}
