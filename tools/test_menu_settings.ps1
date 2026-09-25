param([string]$Runtime='C:/ProgramData/GameMakerStudio2-LTS2026/Cache/runtimes/runtime-2026.0.0.23',
    [string]$TestPrefix='menu', [string]$SuccessMarker='PASS: ALL MENU TESTS')
$ErrorActionPreference='Stop'
$root=Split-Path $PSScriptRoot -Parent
# Static cursor contract: native Windows cursor is hidden and the project provides its own sprite.
$cursorPath=Join-Path $root 'sprites/spr_cursor_poseidon/spr_cursor_poseidon.yy'
if(!(Test-Path -LiteralPath $cursorPath)) {throw 'Missing custom cursor sprite'}
$cursor=Get-Content -LiteralPath $cursorPath -Raw | ConvertFrom-Json -Depth 100
if($cursor.width -ne 24 -or $cursor.height -ne 24 -or $cursor.sequence.xorigin -ne 0 -or $cursor.sequence.yorigin -ne 0) {throw 'Custom cursor size/origin mismatch'}

$cursorFrame=$cursor.frames[0].name
$cursorLayer=$cursor.layers[0].name
if(!(Test-Path -LiteralPath (Join-Path $root "sprites/spr_cursor_poseidon/layers/$cursorFrame/$cursorLayer.png"))) {throw 'Custom cursor layer PNG missing'}

$winOptions=Get-Content -LiteralPath (Join-Path $root 'options/windows/options_windows.yy') -Raw | ConvertFrom-Json -Depth 100
if($winOptions.option_windows_display_cursor -ne $false) {throw 'Native Windows cursor is still enabled'}

$iconPath=Join-Path $root 'options/windows/icons/icon.ico'
if(!(Test-Path -LiteralPath $iconPath) -or (Get-Item -LiteralPath $iconPath).Length -lt 1024) {throw 'Custom Windows game icon missing'}
$templateIcon=Join-Path $root 'options/main/template_icon.png'
if(!(Test-Path -LiteralPath $templateIcon) -or (Get-Item -LiteralPath $templateIcon).Length -lt 1024) {throw 'Template icon preview missing'}

$menuScript=Get-Content -LiteralPath (Join-Path $root 'scripts/scr_menu_system/scr_menu_system.gml') -Raw
if($menuScript -notmatch 'function yp_draw_cursor\(\)' -or $menuScript -notmatch 'spr_cursor_poseidon') {throw 'Shared custom cursor draw helper missing'}
$mainMenuDraw=Get-Content -LiteralPath (Join-Path $root 'objects/obj_main_menu/Draw_64.gml') -Raw
$hudDraw=Get-Content -LiteralPath (Join-Path $root 'objects/obj_ui_controller/Draw_64.gml') -Raw
if($mainMenuDraw -notmatch 'yp_menu_draw\(\);[\s\S]*yp_draw_cursor\(\);') {throw 'Main menu does not draw the cursor after the menu'}
if($hudDraw -notmatch 'yp_menu_draw\(\); yp_draw_cursor\(\); exit;' -or $hudDraw -notmatch 'yp_draw_cursor\(\);\s*$') {throw 'HUD/pause does not draw cursor last'}

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
foreach($pair in @(@(($TestPrefix+'_create.gml'),'Create_0.gml'),@(($TestPrefix+'_step.gml'),'Step_0.gml'),@('menu_draw.gml','Draw_75.gml'))) {
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
# Keep only the test observer active during real modal cutscenes; automate its advance signal.
$p=Join-Path $project 'objects/obj_cutscene_screen/Step_0.gml'
$code=[IO.File]::ReadAllText($p).Replace('object_index != obj_cutscene_screen','object_index != obj_cutscene_screen && object_index != obj_debugger').Replace('var _advance = yp_input("Q", true)','var _advance = global.test_cutscene_advance || yp_input("Q", true)')
Write-Utf8 $p $code
& "$Runtime/bin/igor/windows/x64/Igor.exe" "--project=$project/Young Poseidon.yyp" "--runtimePath=$Runtime" "--user=$env:APPDATA/GameMakerStudio2-LTS2026/unknownUser_unknownUserID" "--cache=$temp/cache" "--temp=$temp/build" "--of=$win" --runtime=VM --config=Default windows Compile *> "$temp/compile.log"
if(!(Test-Path -LiteralPath $win) -or (Select-String -LiteralPath "$temp/compile.log" -Pattern '^Error :|exited with non-zero')) {
    Get-Content "$temp/compile.log" -Tail 90
    throw "Compilation failed: $temp"
}
$runs=if($TestPrefix -eq 'menu') {@(1,2)} else {@(1)}
foreach($run in $runs) {
    $proc=Start-Process -FilePath "$Runtime/windows/x64/Runner.exe" -ArgumentList @('-game',('"'+$win+'"')) -WorkingDirectory $temp -WindowStyle Hidden -PassThru -RedirectStandardOutput "$temp/stdout-$run.log" -RedirectStandardError "$temp/stderr-$run.log"
    try {
        if(!$proc.WaitForExit(60000)) {Stop-Process -Id $proc.Id; throw "Timeout: $temp"}
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
$images=if($TestPrefix -eq 'menu') {@('00a-logo.png','00b-language.png','01-main-UA.png','08c-pause-surface.png','09-pause.png')} else {@(Get-ChildItem (Join-Path $temp 'screenshots') -Filter '*.png' | Select-Object -ExpandProperty Name)}
foreach($image in $images) {
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
if(!(Select-String -LiteralPath "$temp/report.txt" -SimpleMatch -Pattern $SuccessMarker)) {throw "Tests incomplete: $temp"}
