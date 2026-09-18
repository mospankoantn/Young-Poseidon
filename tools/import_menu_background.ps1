param([string]$Source='')
$ErrorActionPreference='Stop'
$root=Split-Path $PSScriptRoot -Parent
if(!$Source) {$Source=Join-Path $root 'Файли/Графіка/Меню/Menu_background_clean.png'}
$utf8=[Text.UTF8Encoding]::new($false)
# Reuse the existing sprite frame and layer IDs.
$dest=Join-Path $root 'Файли/Графіка/Меню/Menu_background_clean.png'
if([IO.Path]::GetFullPath($Source) -ne [IO.Path]::GetFullPath($dest)) {
    Copy-Item -LiteralPath $Source -Destination $dest -Force
}
$path=Join-Path $root 'sprites/Menu_bg/Menu_bg.yy'
$s=Get-Content -LiteralPath $path -Raw | ConvertFrom-Json -Depth 100
Add-Type -AssemblyName System.Drawing
$b=[Drawing.Bitmap]::new($Source)
$s.width=$b.Width; $s.height=$b.Height
$s.bbox_right=$b.Width-1; $s.bbox_bottom=$b.Height-1
$s.sequence.backdropWidth=$b.Width; $s.sequence.backdropHeight=$b.Height
$b.Dispose()
[IO.File]::WriteAllText($path,($s | ConvertTo-Json -Depth 100),$utf8)
Copy-Item -LiteralPath $Source -Destination (Join-Path $root ('sprites/Menu_bg/'+$s.frames[0].name+'.png')) -Force
Copy-Item -LiteralPath $Source -Destination (Join-Path $root ('sprites/Menu_bg/layers/'+$s.frames[0].name+'/'+$s.layers[0].name+'.png')) -Force

# Mechanical replacement keeps all existing input consumers consistent.
foreach($file in Get-ChildItem -LiteralPath (Join-Path $root 'objects') -Filter '*.gml' -Recurse) {
    if($file.Directory.Name -in @('obj_main_menu','obj_menu','obj_debugger')) {continue}
    $old=[IO.File]::ReadAllText($file.FullName)
    $new=[regex]::Replace($old,'keyboard_check(_pressed)?\(ord\("([ADWSEFQZXC])"\)\)',{
        param($m)
        $pressed=if($m.Groups[1].Success){'true'}else{'false'}
        'yp_input("'+$m.Groups[2].Value+'",'+$pressed+')'
    })
    if($new -cne $old) {[IO.File]::WriteAllText($file.FullName,$new,$utf8)}
}
Write-Output 'Imported Menu_bg and connected configurable inputs.'
