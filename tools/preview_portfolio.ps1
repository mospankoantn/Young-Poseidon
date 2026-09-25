$ErrorActionPreference='Stop'
Add-Type -AssemblyName System.Drawing
$root=Split-Path $PSScriptRoot -Parent
$manifest=Get-Content (Join-Path $PSScriptRoot 'portfolio_art_manifest.json') -Raw | ConvertFrom-Json
$out=Join-Path $PSScriptRoot 'portfolio_previews'
[IO.Directory]::CreateDirectory($out) | Out-Null
foreach($kind in @('scene','terrain')) {
    $items=@($manifest | Where-Object kind -eq $kind)
    $cols=if($kind -eq 'scene'){4}else{3}
    $cw=320;$ch=if($kind -eq 'scene'){204}else{344}
    $canvas=[Drawing.Bitmap]::new($cols*$cw,[int][Math]::Ceiling($items.Count/$cols)*$ch)
    $g=[Drawing.Graphics]::FromImage($canvas);$g.Clear([Drawing.Color]::FromArgb(18,25,30))
    $font=[Drawing.Font]::new('Arial',11)
    for($i=0;$i -lt $items.Count;$i++) {
        $img=[Drawing.Image]::FromFile((Join-Path $root $items[$i].local))
        $x=($i%$cols)*$cw;$y=[int][Math]::Floor($i/$cols)*$ch
        $g.DrawImage($img,[Drawing.Rectangle]::new($x,$y,$cw,$ch-24));$img.Dispose()
        $g.DrawString($items[$i].name,$font,[Drawing.Brushes]::White,$x+6,$y+$ch-22)
    }
    $g.Dispose();$font.Dispose()
    $canvas.Save((Join-Path $out "$kind.jpg"),[Drawing.Imaging.ImageFormat]::Jpeg);$canvas.Dispose()
}
Write-Output $out
