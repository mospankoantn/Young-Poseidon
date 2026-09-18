param([string]$ProjectRoot=(Split-Path $PSScriptRoot -Parent))
$ErrorActionPreference='Stop'
Add-Type -AssemblyName System.Drawing
$names=@('spr_weapon_trident','spr_weapon_spear','spr_weapon_pickaxe','spr_weapon_scythe','spr_weapon_oar','spr_weapon_sword','spr_olympus_key','spr_projectile_trident','spr_projectile_spear','spr_projectile_water','spr_projectile_coin','spr_projectile_ghost_spear','spr_projectile_fate','spr_projectile_lightning','spr_projectile_scythe')
$canvas=[Drawing.Bitmap]::new(1000,$names.Count*140)
$g=[Drawing.Graphics]::FromImage($canvas)
$g.Clear([Drawing.Color]::FromArgb(35,43,49))
$g.InterpolationMode=[Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g.PixelOffsetMode=[Drawing.Drawing2D.PixelOffsetMode]::Half
$font=[Drawing.Font]::new('Consolas',12)
for($r=0;$r -lt $names.Count;$r++){
    $name=$names[$r]
    $yy=Get-Content -LiteralPath (Join-Path $ProjectRoot "sprites/$name/$name.yy") -Raw|ConvertFrom-Json -Depth 100
    $g.DrawString($name,$font,[Drawing.Brushes]::White,4,$r*140+4)
    for($i=0;$i -lt $yy.frames.Count;$i++){
        $im=[Drawing.Bitmap]::new((Join-Path $ProjectRoot ("sprites/$name/"+$yy.frames[$i].name+".png")))
        $scale=[Math]::Min(2,110.0/$im.Height)
        $g.DrawImage($im,[Drawing.Rectangle]::new(310+$i*160,$r*140+15,[int]($im.Width*$scale),[int]($im.Height*$scale)))
        $im.Dispose()
    }
}
$canvas.Save((Join-Path $ProjectRoot 'Файли/Графіка/Ефекти/weapon_effects_preview.png'),[Drawing.Imaging.ImageFormat]::Png)
$font.Dispose();$g.Dispose();$canvas.Dispose()
