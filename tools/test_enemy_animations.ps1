param(
    [string]$Runtime='C:/ProgramData/GameMakerStudio2-LTS2026/Cache/runtimes/runtime-2026.0.0.23',
    [string]$UserDir=(Join-Path $env:APPDATA 'GameMakerStudio2-LTS2026/unknownUser_unknownUserID')
)
$ErrorActionPreference='Stop'
& (Join-Path $PSScriptRoot 'validate_enemy_sheets.ps1')
$root=Split-Path $PSScriptRoot -Parent
$temp=Join-Path ([IO.Path]::GetTempPath()) ('yp-enemy-test-'+[guid]::NewGuid().ToString('N'))
$projectDir=Join-Path $temp 'project'
[IO.Directory]::CreateDirectory($projectDir) | Out-Null
foreach($dir in @('objects','sprites','scripts','rooms','sounds','fonts','tilesets','options')) {
    Copy-Item -LiteralPath (Join-Path $root $dir) -Destination $projectDir -Recurse
}
Copy-Item -LiteralPath (Join-Path $root 'Young Poseidon.yyp') -Destination $projectDir
$utf8=[Text.UTF8Encoding]::new($false)
function Save-Json($path,$value) { [IO.File]::WriteAllText($path,($value | ConvertTo-Json -Depth 100),$utf8) }
$roomPath=Join-Path $projectDir 'rooms/rm_menu/rm_menu.yy'
$room=Get-Content -LiteralPath $roomPath -Raw | ConvertFrom-Json -Depth 100
$keep=@()
foreach($layer in $room.layers) {
    if($null -ne $layer.instances) {
        $layer.instances=@($layer.instances | Where-Object {$_.objectId.name -in @('obj_lang_manager','obj_main_menu')})
        $keep+=@($layer.instances.name)
    }
}
$room.instanceCreationOrder=@($room.instanceCreationOrder | Where-Object {$_.name -in $keep})
Save-Json $roomPath $room
$report=Join-Path $temp 'report.txt'
foreach($pair in @(@('enemy_animation_create.gml','Create_0.gml'),@('enemy_animation_step.gml','Step_0.gml'))) {
    $source=Get-Content -LiteralPath (Join-Path $PSScriptRoot ('tests/'+$pair[0])) -Raw
    $source=$source.Replace('__REPORT__',$report.Replace('\','/'))
    [IO.File]::WriteAllText((Join-Path $projectDir ('objects/obj_main_menu/'+$pair[1])),$source,$utf8)
}
[IO.File]::WriteAllText((Join-Path $projectDir 'objects/obj_main_menu/Draw_64.gml'),'',$utf8)
$path=Join-Path $projectDir 'options/windows/options_windows.yy'
$options=Get-Content -LiteralPath $path -Raw | ConvertFrom-Json -Depth 100
$options.option_windows_disable_sandbox=$true
Save-Json $path $options
$win=Join-Path $temp 'Young Poseidon.win'
$compilerLog=Join-Path $temp 'compile.log'
& (Join-Path $Runtime 'bin/igor/windows/x64/Igor.exe') "--project=$projectDir/Young Poseidon.yyp" "--runtimePath=$Runtime" "--user=$UserDir" "--cache=$temp/cache" "--temp=$temp/build" "--of=$win" --runtime=VM --config=Default windows Compile *> $compilerLog
if($LASTEXITCODE -ne 0 -or !(Test-Path $win)) {Get-Content $compilerLog -Tail 60; throw "Compilation failed: $temp"}
$proc=Start-Process -FilePath (Join-Path $Runtime 'windows/x64/Runner.exe') -ArgumentList @('-game',('"' + $win + '"')) -WorkingDirectory $temp -WindowStyle Hidden -PassThru -RedirectStandardOutput (Join-Path $temp 'stdout.log') -RedirectStandardError (Join-Path $temp 'stderr.log')
try {
    if(!$proc.WaitForExit(60000)) {Stop-Process -Id $proc.Id; throw "Runtime timeout: $temp"}
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
if(!$result.StartsWith('PASS:')) {
    Get-Content (Join-Path $temp 'stdout.log') -Tail 40
    throw 'Enemy animation runtime test failed'
}

