param(
    [string]$Runtime='C:/ProgramData/GameMakerStudio2-LTS2026/Cache/runtimes/runtime-2026.0.0.23',
    [string]$UserDir=(Join-Path $env:APPDATA 'GameMakerStudio2-LTS2026/unknownUser_unknownUserID'),
    [string]$TestPrefix='player_death',
    [string]$SuccessMarker='PASS: no-checkpoint game_restart'
)
$ErrorActionPreference='Stop'
$root=Split-Path $PSScriptRoot -Parent
$temp=Join-Path ([IO.Path]::GetTempPath()) ('yp-death-test-'+[guid]::NewGuid().ToString('N'))
$projectDir=Join-Path $temp 'project'
[IO.Directory]::CreateDirectory($projectDir) | Out-Null
foreach($dir in @('objects','sprites','scripts','rooms','sounds','fonts','tilesets','options')) {
    Copy-Item -LiteralPath (Join-Path $root $dir) -Destination $projectDir -Recurse
}
Copy-Item -LiteralPath (Join-Path $root 'Young Poseidon.yyp') -Destination $projectDir
$utf8=[Text.UTF8Encoding]::new($false)
function Save-Json($path,$value) { [IO.File]::WriteAllText($path,($value | ConvertTo-Json -Depth 100),$utf8) }
# Remove gameplay actors from test rooms; retain layers and resource metadata.
foreach($name in @('rm_menu','rm_sea_1')) {
    $path=Join-Path $projectDir "rooms/$name/$name.yy"
    $room=Get-Content -LiteralPath $path -Raw | ConvertFrom-Json -Depth 100
    $keep=@()
    foreach($layer in $room.layers) {
        if($null -ne $layer.instances) {
            $layer.instances=@($layer.instances | Where-Object {
                $name -eq 'rm_menu' -and $_.objectId.name -in @('obj_lang_manager','obj_main_menu')
            })
            $keep+=@($layer.instances.name)
        }
    }
    $room.instanceCreationOrder=@($room.instanceCreationOrder | Where-Object {$_.name -in $keep})
    Save-Json $path $room
}
$report=Join-Path $temp 'report.txt'
foreach($pair in @(@("${TestPrefix}_create.gml",'Create_0.gml'),@("${TestPrefix}_step.gml",'Step_0.gml'))) {
    $source=Get-Content -LiteralPath (Join-Path $PSScriptRoot ('tests/'+$pair[0])) -Raw
    $source=$source.Replace('__REPORT__',$report.Replace('\','/'))
    [IO.File]::WriteAllText((Join-Path $projectDir ('objects/obj_main_menu/'+$pair[1])),$source,$utf8)
}
[IO.File]::WriteAllText((Join-Path $projectDir 'objects/obj_main_menu/Draw_64.gml'),'',$utf8)
if($TestPrefix -eq 'weapon_visuals') {
    # Feed action signals in the isolated fixture, without OS key injection/focus races.
    $playerStep=Join-Path $projectDir 'objects/obj_player/Step_0.gml'
    $code=[IO.File]::ReadAllText($playerStep)
    $code=$code.Replace('yp_input("E",true)','global.test_attack_pressed')
    $code=$code.Replace('yp_input("F",true)','global.test_recall_pressed')
    [IO.File]::WriteAllText($playerStep,$code,$utf8)
}
if($TestPrefix -eq 'portfolio') {
    $path=Join-Path $projectDir 'objects/obj_player/Step_0.gml'
    $code=[IO.File]::ReadAllText($path).Replace('yp_input("W",true)','global.test_jump').Replace('yp_input("W",false)','global.test_jump_held').Replace('yp_input("D",false)','global.test_right').Replace('yp_input("E",true)','global.test_attack')
    [IO.File]::WriteAllText($path,$code,$utf8)
}
if($TestPrefix -eq 'interactive_props') {
    foreach($file in Get-ChildItem -LiteralPath (Join-Path $projectDir 'objects') -Filter '*.gml' -Recurse) {
        $code=[IO.File]::ReadAllText($file.FullName)
        $code=$code.Replace('yp_input("E",true)','global.test_attack_pressed').Replace('yp_input("F",true)','global.test_recall_pressed')
        $code=$code.Replace('yp_input("E", true)','global.test_attack_pressed').Replace('yp_input("F", true)','global.test_recall_pressed')
        [IO.File]::WriteAllText($file.FullName,$code,$utf8)
    }
    $draw=Get-Content -LiteralPath (Join-Path $PSScriptRoot 'tests/interactive_props_draw.gml') -Raw
    [IO.File]::WriteAllText((Join-Path $projectDir 'objects/obj_main_menu/Draw_64.gml'),$draw,$utf8)
}
$path=Join-Path $projectDir 'options/windows/options_windows.yy'
# These isolated combat/save fixtures do not exercise modal UI. Menu tests use the real prologue.
$cutscenePath=Join-Path $projectDir 'scripts/scr_cutscene_system/scr_cutscene_system.gml'
$code=[IO.File]::ReadAllText($cutscenePath)
$code=[regex]::Replace($code,'(function show_cutscene\(_pages, _close_action, _state_key\)\s*\{)','$1 return noone;')
$code=[regex]::Replace($code,'(function show_intro_cutscene\(\)\s*\{)','$1 room_goto(rm_sea_1); return noone;')
[IO.File]::WriteAllText($cutscenePath,$code,$utf8)
$options=Get-Content -LiteralPath $path -Raw | ConvertFrom-Json -Depth 100
$options.option_windows_disable_sandbox=$true
Save-Json $path $options
$win=Join-Path $temp 'Young Poseidon.win'
$compilerLog=Join-Path $temp 'compile.log'
& (Join-Path $Runtime 'bin/igor/windows/x64/Igor.exe') "--project=$projectDir/Young Poseidon.yyp" "--runtimePath=$Runtime" "--user=$UserDir" "--cache=$temp/cache" "--temp=$temp/build" "--of=$win" --runtime=VM --config=Default windows Compile *> $compilerLog
if($LASTEXITCODE -ne 0) {Get-Content $compilerLog -Tail 60; throw "Compilation failed: $temp"}
$proc=Start-Process -FilePath (Join-Path $Runtime 'windows/x64/Runner.exe') -ArgumentList @('-game',('"' + $win + '"')) -WorkingDirectory $temp -WindowStyle Hidden -PassThru -RedirectStandardOutput (Join-Path $temp 'stdout.log') -RedirectStandardError (Join-Path $temp 'stderr.log')
try {
    if(!$proc.WaitForExit(25000)) {Stop-Process -Id $proc.Id; throw "Runtime timeout: $temp"}
} finally {
    if(!$proc.HasExited) {Stop-Process -Id $proc.Id}
}
if(!(Test-Path -LiteralPath $report)) {
    Get-Content (Join-Path $temp 'stdout.log') -Tail 40
    Get-Content (Join-Path $temp 'stderr.log') -Tail 40
    throw "Missing report: $temp"
}
$result=Get-Content -LiteralPath $report -Raw
Write-Output $result
Write-Output "Test artifacts: $temp"
if($result.Contains('FAIL:') -or !$result.Contains($SuccessMarker)) {throw "$TestPrefix runtime test failed"}
