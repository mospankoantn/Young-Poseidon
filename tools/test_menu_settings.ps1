param([string]$Runtime='C:/ProgramData/GameMakerStudio2-LTS2026/Cache/runtimes/runtime-2026.0.0.23')
$ErrorActionPreference='Stop'
$root=Split-Path $PSScriptRoot -Parent
$temp=Join-Path $env:TEMP ('yp-menu-test-'+[guid]::NewGuid().ToString('N'))
$project=Join-Path $temp 'project'
[IO.Directory]::CreateDirectory($project)|Out-Null
[IO.Directory]::CreateDirectory((Join-Path $temp 'screenshots'))|Out-Null
foreach($dir in @('objects','sprites','scripts','rooms','sounds','fonts','tilesets','options')) {
    Copy-Item -LiteralPath (Join-Path $root $dir) -Destination $project -Recurse
}
Copy-Item -LiteralPath (Join-Path $root 'Young Poseidon.yyp') -Destination $project
$utf8=[Text.UTF8Encoding]::new($false)
function Write-Utf8($p,$s) {[IO.File]::WriteAllText($p,$s,$utf8)}
foreach($pair in @(@('menu_create.gml','Create_0.gml'),@('menu_step.gml','Step_0.gml'),@('menu_draw.gml','Draw_75.gml'))) {
    $code=Get-Content -LiteralPath (Join-Path $PSScriptRoot ('tests/'+$pair[0])) -Raw
    $code=$code.Replace('__REPORT__',($temp+'/report.txt').Replace('\','/')).Replace('__DONE__',($temp+'/done.txt').Replace('\','/')).Replace('__SHOTS__',($temp+'/screenshots/').Replace('\','/'))
    Write-Utf8 (Join-Path $project ('objects/obj_debugger/'+$pair[1])) $code
}
Write-Utf8 (Join-Path $project 'objects/obj_debugger/Draw_64.gml') ''
Write-Utf8 (Join-Path $project 'objects/obj_debugger/Draw_73.gml') ''
$p=Join-Path $project 'objects/obj_debugger/obj_debugger.yy'
$o=Get-Content -LiteralPath $p -Raw|ConvertFrom-Json -Depth 100
$e=$o.eventList[2].PSObject.Copy(); $e.eventNum=75; $o.eventList+=@($e)
Write-Utf8 $p ($o|ConvertTo-Json -Depth 100)
$p=Join-Path $project 'options/windows/options_windows.yy'
$o=Get-Content -LiteralPath $p -Raw|ConvertFrom-Json -Depth 100
$o.option_windows_disable_sandbox=$true
Write-Utf8 $p ($o|ConvertTo-Json -Depth 100)
# All test persistence is absolute and isolated from the user's saves.
foreach($rel in @('scripts/scr_settings/scr_settings.gml','scripts/scr_save_system/scr_save_system.gml')) {
    $p=Join-Path $project $rel
    $code=Get-Content -LiteralPath $p -Raw
    $code=$code.Replace('"young_poseidon_settings.ini"',('"'+($temp+'/settings.ini').Replace('\','/')+'"'))
    $savePrefix=($temp+'/save_').Replace('\','/')
    $autosavePrefix=($temp+'/autosave').Replace('\','/')
    $legacy=($temp+'/legacy.ini').Replace('\','/')
    $code=$code.Replace('young_poseidon_save_',$savePrefix)
    $code=$code.Replace('young_poseidon_autosave',$autosavePrefix)
    $code=$code.Replace('"young_poseidon_save.ini"',('"'+$legacy+'"'))
    Write-Utf8 $p $code
}
$win=Join-Path $temp 'Young Poseidon.win'
& "$Runtime/bin/igor/windows/x64/Igor.exe" "--project=$project/Young Poseidon.yyp" "--runtimePath=$Runtime" "--user=$env:APPDATA/GameMakerStudio2-LTS2026/unknownUser_unknownUserID" "--cache=$temp/cache" "--temp=$temp/build" "--of=$win" --runtime=VM --config=Default windows Compile *> "$temp/compile.log"
if(!(Test-Path -LiteralPath $win) -or (Select-String -LiteralPath "$temp/compile.log" -Pattern '^Error :|exited with non-zero')) {
    Get-Content "$temp/compile.log" -Tail 90
    throw "Compilation failed: $temp"
}
foreach($run in 1,2) {
    $proc=Start-Process -FilePath "$Runtime/windows/x64/Runner.exe" -ArgumentList @('-game',('"'+$win+'"')) -WorkingDirectory $temp -WindowStyle Hidden -PassThru -RedirectStandardOutput "$temp/stdout-$run.log" -RedirectStandardError "$temp/stderr-$run.log"
    try {
        if(!$proc.WaitForExit(30000)) {Stop-Process -Id $proc.Id; throw "Timeout: $temp"}
    } finally { if(!$proc.HasExited){Stop-Process -Id $proc.Id} }
    if(!(Test-Path "$temp/report.txt") -or (Select-String -LiteralPath "$temp/report.txt" -Pattern 'FAIL:')) {
        Get-Content "$temp/stdout-$run.log" -Tail 40
        if(Test-Path "$temp/report.txt"){Get-Content "$temp/report.txt"}
        throw "Runtime failure: $temp"
    }
}
Get-Content "$temp/report.txt"
# Catch blank snapshots and missing imported art, not just successful GML execution.
Add-Type -AssemblyName System.Drawing
foreach($image in @('01-main-UA.png','08c-pause-surface.png','09-pause.png')) {
    $bitmap=[Drawing.Bitmap]::new((Join-Path $temp ('screenshots/'+$image)))
    $colors=[Collections.Generic.HashSet[int]]::new()
    for($y=0;$y -lt $bitmap.Height;$y+=20) {
        for($x=0;$x -lt $bitmap.Width;$x+=20) {$null=$colors.Add($bitmap.GetPixel($x,$y).ToArgb())}
    }
    $bitmap.Dispose()
    if($colors.Count -lt 30) {throw "Blank or missing scene: $image"}
}
Write-Output 'PASS: main menu art and frozen pause scene are nonblank'
Write-Output "Artifacts: $temp"
if(!(Select-String -LiteralPath "$temp/report.txt" -Pattern 'PASS: ALL MENU TESTS')) {throw "Tests incomplete: $temp"}
