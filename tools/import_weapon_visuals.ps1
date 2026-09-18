param([string]$ProjectRoot = (Split-Path $PSScriptRoot -Parent))
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
Add-Type -ReferencedAssemblies System.Drawing,System.Drawing.Primitives,System.Drawing.Common,System.Collections -TypeDefinition @'
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
public static class WeaponSheet {
    public static int Gap(Bitmap b, bool horizontal, int nominal, int radius, int from, int to) {
        int best=nominal, score=int.MaxValue;
        for(int p=nominal-radius;p<=nominal+radius;p++) {
            int count=0;
            for(int q=from;q<to;q+=2) if((horizontal?b.GetPixel(q,p):b.GetPixel(p,q)).A>96) count++;
            if(count<score || (count==score && Math.Abs(p-nominal)<Math.Abs(best-nominal))) {score=count;best=p;}
        }
        return best;
    }
    public static Rectangle Bounds(Bitmap b, Rectangle cell, int alpha=96) {
        int l=cell.Right,t=cell.Bottom,r=cell.Left-1,d=cell.Top-1;
        for(int y=cell.Top;y<cell.Bottom;y++) for(int x=cell.Left;x<cell.Right;x++) {
            if(b.GetPixel(x,y).A<=alpha)continue;
            l=Math.Min(l,x);r=Math.Max(r,x);t=Math.Min(t,y);d=Math.Max(d,y);
        }
        if(r<l)throw new Exception("Empty crop");
        return Rectangle.FromLTRB(l,t,r+1,d+1);
    }
    public static int[] Body(Bitmap b, Rectangle cell) {
        var xs=new List<int>();var ys=new List<int>();
        for(int y=cell.Top;y<cell.Bottom;y++)for(int x=cell.Left;x<cell.Right;x++) {
            Color c=b.GetPixel(x,y);
            if(c.A>150 && c.R<95 && c.G<150 && c.B>c.R*1.35 && c.G>c.R*1.12 && c.B<c.G*2.3) {xs.Add(x);ys.Add(y);}
        }
        if(xs.Count<100)throw new Exception("Cannot locate character hair");
        xs.Sort();ys.Sort();int headX=xs[xs.Count/2], top=ys[ys.Count/20], feet=top;
        int left=cell.Right,right=cell.Left;
        for(int y=top+70;y<cell.Bottom;y++)for(int x=Math.Max(cell.Left,headX-100);x<Math.Min(cell.Right,headX+100);x++) {
            Color c=b.GetPixel(x,y);
            if(c.A>150 && c.R>130 && c.G>65 && c.B>25 && c.R>c.G*1.1 && c.G>c.B*1.12)feet=Math.Max(feet,y);
        }
        for(int y=Math.Max(top,feet-18);y<=feet;y++)for(int x=Math.Max(cell.Left,headX-110);x<Math.Min(cell.Right,headX+110);x++) {
            Color c=b.GetPixel(x,y);
            if(c.A>150 && c.R>130 && c.G>65 && c.B>25 && c.R>c.G*1.1 && c.G>c.B*1.12) {left=Math.Min(left,x);right=Math.Max(right,x);}
        }
        return new int[]{right>=left?(left+right)/2:headX,feet+1,top};
    }
    public static Bitmap Frame(Bitmap b, Rectangle cell, double scale, double ax, double ay, int w,int h,int ox,int oy,int threshold) {
        var output=new Bitmap(w,h,PixelFormat.Format32bppArgb);
        for(int y=0;y<h;y++)for(int x=0;x<w;x++) {
            int sx=(int)Math.Floor((x-ox)/scale+ax),sy=(int)Math.Floor((y-oy)/scale+ay);
            if(sx<cell.Left||sx>=cell.Right||sy<cell.Top||sy>=cell.Bottom)continue;
            Color c=b.GetPixel(sx,sy);if(c.A>threshold)output.SetPixel(x,y,c);
        }
        return output;
    }
    public static Bitmap Icon(Bitmap b, Rectangle cell, int w,int h) {
        Rectangle r=Bounds(b,cell);double scale=Math.Min((w-8.0)/r.Width,(h-8.0)/r.Height);
        return Frame(b,cell,scale,(r.Left+r.Right)/2.0,(r.Top+r.Bottom)/2.0,w,h,w/2,h/2,64);
    }
    public static Bitmap Horizontal(Bitmap icon, double rotation, int w,int h) {
        var result=new Bitmap(w,h,PixelFormat.Format32bppArgb);
        double angle=rotation*Math.PI/180,co=Math.Cos(angle),si=Math.Sin(angle);
        double scale=(w-6.0)/64;
        for(int y=0;y<h;y++)for(int x=0;x<w;x++) {
            double dx=(x-w/2.0)/scale,dy=(y-h/2.0)/scale;
            int sx=(int)Math.Floor(co*dx+si*dy+32),sy=(int)Math.Floor(-si*dx+co*dy+32);
            if(sx>=0&&sx<64&&sy>=0&&sy<64)result.SetPixel(x,y,icon.GetPixel(sx,sy));
        }
        return result;
    }
}
'@
$utf8=[Text.UTF8Encoding]::new($false)
function Read-Json($path) { Get-Content -LiteralPath (Join-Path $ProjectRoot $path) -Raw | ConvertFrom-Json -Depth 100 }
function Clone-Json($value) { $value | ConvertTo-Json -Depth 100 | ConvertFrom-Json -Depth 100 }
function Save-Json($path,$value) { [IO.File]::WriteAllText((Join-Path $ProjectRoot $path),($value | ConvertTo-Json -Depth 100)+"`n",$utf8) }
$project=Read-Json 'Young Poseidon.yyp'
$order=Read-Json 'Young Poseidon.resource_order'
$template=Read-Json 'sprites/spr_player_idle/spr_player_idle.yy'
$script:nextOrder=[int](1+($order.ResourceOrderSettings | Measure-Object order -Maximum).Maximum)
function Folder($name,$path) {
    if($path -notin $project.Folders.folderPath) {
        $project.Folders += [pscustomobject][ordered]@{'$GMFolder'='';'%Name'=$name;folderPath=$path;name=$name;resourceType='GMFolder';resourceVersion='2.0'}
        $order.FolderOrderSettings += [pscustomobject]@{name=$name;order=[int]$script:nextOrder;path=$path};$script:nextOrder++
    }
}
function Register($name,$path) {
    $existing=@($project.resources | Where-Object {$_.id.name -eq $name})
    if($existing.Count -gt 1 -or ($existing.Count -eq 1 -and $existing[0].id.path -ne $path)){throw "Duplicate resource $name"}
    if(!$existing.Count){$project.resources += [pscustomobject]@{id=[pscustomobject]@{name=$name;path=$path}}}
    if($name -notin $order.ResourceOrderSettings.name){$order.ResourceOrderSettings += [pscustomobject]@{name=$name;order=[int]$script:nextOrder;path=$path};$script:nextOrder++}
}
function Sprite($name,$images,$fps,$ox,$oy,$folderName,$folderPath) {
    $relative="sprites/$name/$name.yy";$dir=Join-Path $ProjectRoot "sprites/$name"
    [IO.Directory]::CreateDirectory($dir)|Out-Null
    $exists=Test-Path -LiteralPath (Join-Path $ProjectRoot $relative)
    $yy=if($exists){Read-Json $relative}else{Clone-Json $template}
    $oldFrames=if($exists){@($yy.frames)}else{@()};$oldKeys=if($exists){@($yy.sequence.tracks[0].keyframes.Keyframes)}else{@()}
    $layer=if($exists){$yy.layers[0].name}else{[guid]::NewGuid().ToString()}
    $yy.name=$name;$yy.'%Name'=$name;$yy.width=$images[0].Width;$yy.height=$images[0].Height
    $yy.origin=9;$yy.bboxMode=2;$yy.bbox_left=0;$yy.bbox_top=0;$yy.bbox_right=$yy.width-1;$yy.bbox_bottom=$yy.height-1
    $yy.parent.name=$folderName;$yy.parent.path=$folderPath
    $yy.layers[0].name=$layer;$yy.layers[0].'%Name'=$layer
    $yy.sequence.name=$name;$yy.sequence.'%Name'=$name;$yy.sequence.length=[double]$images.Count
    $yy.sequence.xorigin=[int]$ox;$yy.sequence.yorigin=[int]$oy;$yy.sequence.playbackSpeed=[double]$fps;$yy.sequence.playbackSpeedType=0
    $frames=@();$keys=@()
    for($i=0;$i -lt $images.Count;$i++) {
        $frame=Clone-Json $template.frames[0];$fid=if($i -lt $oldFrames.Count){$oldFrames[$i].name}else{[guid]::NewGuid().ToString()}
        $frame.name=$fid;$frame.'%Name'=$fid;$frames+=,$frame
        $key=Clone-Json $template.sequence.tracks[0].keyframes.Keyframes[0]
        $key.id=if($i -lt $oldKeys.Count){$oldKeys[$i].id}else{[guid]::NewGuid().ToString()}
        $key.Key=[double]$i;$key.Length=1.0;$key.Channels.'0'.Id.name=$fid;$key.Channels.'0'.Id.path=$relative;$keys+=,$key
        $png=Join-Path $dir "$fid.png";$images[$i].Save($png,[Drawing.Imaging.ImageFormat]::Png)
        $ld=Join-Path $dir "layers/$fid";[IO.Directory]::CreateDirectory($ld)|Out-Null
        Copy-Item -LiteralPath $png -Destination (Join-Path $ld "$layer.png") -Force
    }
    $yy.frames=$frames;$yy.sequence.tracks[0].keyframes.Keyframes=$keys
    Save-Json $relative $yy;Register $name $relative
}

# Keep the former weapon silhouette as an explicit collision resource before replacing its artwork.
if(!(Test-Path -LiteralPath (Join-Path $ProjectRoot 'sprites/spr_weapon_collision/spr_weapon_collision.yy'))) {
    $old=Read-Json 'sprites/spr_weapon_trident/spr_weapon_trident.yy'
    $mask=Clone-Json $old;$mask.name='spr_weapon_collision';$mask.'%Name'=$mask.name
    $mask.sequence.name=$mask.name;$mask.sequence.'%Name'=$mask.name
    $maskFrame=[guid]::NewGuid().ToString();$maskLayer=[guid]::NewGuid().ToString()
    $mask.frames[0].name=$maskFrame;$mask.frames[0].'%Name'=$maskFrame
    $mask.layers[0].name=$maskLayer;$mask.layers[0].'%Name'=$maskLayer
    $mask.sequence.tracks[0].keyframes.Keyframes[0].id=[guid]::NewGuid().ToString()
    $mask.sequence.tracks[0].keyframes.Keyframes[0].Channels.'0'.Id.name=$maskFrame
    $mask.sequence.tracks[0].keyframes.Keyframes[0].Channels.'0'.Id.path='sprites/spr_weapon_collision/spr_weapon_collision.yy'
    $mask.parent.name='Test';$mask.parent.path='folders/Спрайты/Test.yy'
    $dir=Join-Path $ProjectRoot 'sprites/spr_weapon_collision';[IO.Directory]::CreateDirectory($dir)|Out-Null
    Copy-Item -LiteralPath (Join-Path $ProjectRoot ('sprites/spr_weapon_trident/'+$old.frames[0].name+'.png')) -Destination (Join-Path $dir "$maskFrame.png")
    $ld=Join-Path $dir "layers/$maskFrame";[IO.Directory]::CreateDirectory($ld)|Out-Null
    Copy-Item -LiteralPath (Join-Path $dir "$maskFrame.png") -Destination (Join-Path $ld "$maskLayer.png")
    Save-Json 'sprites/spr_weapon_collision/spr_weapon_collision.yy' $mask
}
Register 'spr_weapon_collision' 'sprites/spr_weapon_collision/spr_weapon_collision.yy'
Folder 'Weapons' 'folders/Спрайты/Player/Weapons.yy'
Folder 'Projectiles' 'folders/Спрайты/Effects/Projectiles.yy'
$manifest=@();$preview=[Drawing.Bitmap]::new(1440,6*160);$pg=[Drawing.Graphics]::FromImage($preview);$pg.Clear([Drawing.Color]::FromArgb(35,43,49));$font=[Drawing.Font]::new('Consolas',12)
$weapons=@('trident','spear','pickaxe','scythe','oar','sword')
for($wi=0;$wi -lt $weapons.Count;$wi++) {
    $weapon=$weapons[$wi];$file=if($weapon -eq 'pickaxe'){'Sprite examples pickaxe .png'}else{"Sprite examples $weapon.png"}
    $source=[Drawing.Bitmap]::new((Join-Path $ProjectRoot "Файли/$file"))
    try {
        if($source.Width -ne 1254 -or $source.Height -ne 1254){throw "Review source size: $file"}
        $rows=@(0,[WeaponSheet]::Gap($source,$true,350,45,0,1254),[WeaponSheet]::Gap($source,$true,660,45,0,1254),[WeaponSheet]::Gap($source,$true,955,40,0,1254),1254)
        $cells=@();$bodies=@()
        for($r=0;$r -lt 4;$r++) {
            $cols=@(0,[WeaponSheet]::Gap($source,$false,313,45,$rows[$r],$rows[$r+1]),[WeaponSheet]::Gap($source,$false,627,45,$rows[$r],$rows[$r+1]),[WeaponSheet]::Gap($source,$false,941,45,$rows[$r],$rows[$r+1]),1254)
            # The trident thrust crosses the nominal grid; these reviewed boundaries keep its tip.
            if($weapon -eq 'trident' -and $r -eq 2){$cols[2]=654;$cols[3]=996}
            if($r -eq 3 -and $weapon -eq 'trident'){$cols=@(0,245,724,960,1254)}
            if($r -eq 3 -and $weapon -eq 'spear'){$cols=@(0,270,695,955,1254)}
            for($c=0;$c -lt 4;$c++){
                $right=$cols[$c+1]
                # Detached missiles are rendered by obj_trident, not baked into the player's cast.
                if($r -eq 3 -and $c -eq 1 -and $weapon -eq 'trident'){$right=490}
                if($r -eq 3 -and $c -eq 1 -and $weapon -eq 'spear'){$right=500}
                $cell=[Drawing.Rectangle]::FromLTRB($cols[$c],$rows[$r],$right,$rows[$r+1])
                $cells+=,$cell;$bodies+=,($(if($cells.Count -gt 1){[WeaponSheet]::Body($source,$cell)}else{@(0,0,0)}))
            }
        }
        $scale=64.0/($bodies[4][1]-$bodies[4][2]);$images=@()
        for($i=1;$i -lt 16;$i++){$images+=,[WeaponSheet]::Frame($source,$cells[$i],$scale,$bodies[$i][0],$bodies[$i][1],160,128,80,104,64)}
        $title=(Get-Culture).TextInfo.ToTitleCase($weapon);$folder="folders/Спрайты/Player/Weapons/$title.yy";Folder $title $folder
        $clips=@(@{Name='idle';Frames=@(4);FPS=6},@{Name='run';Frames=@(5,6,7,6);FPS=12},@{Name='pickup';Frames=@(1,2,3);FPS=9},@{Name='attack';Frames=@(8,9,10,11);FPS=14})
        if($weapon -in @('trident','spear')){$clips+=@(@{Name='cast';Frames=@(12,13,14);FPS=12},@{Name='recall';Frames=@(15);FPS=6})}
        else{$clips+=@{Name='special';Frames=@(12,13,14,15);FPS=14}}
        foreach($clip in $clips){$frames=@($clip.Frames | ForEach-Object {$images[$_-1]});Sprite "spr_player_${weapon}_$($clip.Name)" $frames $clip.FPS 80 104 $title $folder}
        $icon=[WeaponSheet]::Icon($source,$cells[0],64,64)
        try {
            Sprite "spr_weapon_$weapon" @($icon) 1 32 32 'Weapons' 'folders/Спрайты/Weapons.yy'
            if($weapon -in @('trident','spear')) {
                $rotation=if($weapon -eq 'trident'){90}else{45}
                $flying=[WeaponSheet]::Horizontal($icon,$rotation,64,32)
                try {Sprite "spr_projectile_$weapon" @($flying) 1 16 11 'Projectiles' 'folders/Спрайты/Effects/Projectiles.yy'}finally{$flying.Dispose()}
            }
            if($weapon -eq 'scythe'){Sprite 'spr_projectile_scythe' @($icon) 1 24 24 'Projectiles' 'folders/Спрайты/Effects/Projectiles.yy'}
        } finally {$icon.Dispose()}
        $pg.DrawString($weapon,$font,[Drawing.Brushes]::White,0,$wi*160)
        $show=@(4,5,6,7,8,9,10,11,3)
        for($i=0;$i -lt $show.Count;$i++){$pg.DrawImageUnscaled($images[$show[$i]-1],$i*160,$wi*160+24)}
        $manifest += [pscustomobject]@{source=$file;weapon=$weapon;rows=$rows;scale=$scale;cells=@($cells | ForEach-Object {@($_.X,$_.Y,$_.Width,$_.Height)});bodyAnchors=$bodies;clips=$clips}
        foreach($im in $images){$im.Dispose()}
        Write-Host "$weapon rows=$($rows -join ',') scale=$scale"
    }finally{$source.Dispose()}
}
$preview.Save((Join-Path $ProjectRoot 'Файли/weapon_animation_preview.png'),[Drawing.Imaging.ImageFormat]::Png);$pg.Dispose();$font.Dispose();$preview.Dispose()

$effects=[Drawing.Bitmap]::new((Join-Path $ProjectRoot 'Файли/weapon_projectile_effects_source.png'))
try {
    $rows=@(0);for($r=1;$r -lt 6;$r++){$rows += [WeaponSheet]::Gap($effects,$true,[int]($effects.Height*$r/6),30,0,$effects.Width)};$rows+=$effects.Height
    $specs=@(@{Name='spr_projectile_water';W=28;H=28;OX=6;OY=6},@{Name='spr_projectile_coin';W=24;H=24;OX=4;OY=4},@{Name='spr_projectile_ghost_spear';W=64;H=32;OX=24;OY=8},@{Name='spr_projectile_fate';W=64;H=32;OX=24;OY=8},@{Name='spr_projectile_lightning';W=64;H=128;OX=32;OY=128},@{Name='spr_olympus_key';W=64;H=64;OX=32;OY=32})
    for($r=0;$r -lt 6;$r++) {
        $spec=$specs[$r];$cells=@();$bounds=@();$maxW=0;$maxH=0
        for($c=0;$c -lt 4;$c++){$cell=[Drawing.Rectangle]::FromLTRB([int][Math]::Floor($c*$effects.Width/4),$rows[$r],[int][Math]::Floor(($c+1)*$effects.Width/4),$rows[$r+1]);$cells+=,$cell;$bound=[WeaponSheet]::Bounds($effects,$cell,48);$bounds+=,$bound;$maxW=[Math]::Max($maxW,$bound.Width);$maxH=[Math]::Max($maxH,$bound.Height)}
        $scale=[Math]::Min(($spec.W-4.0)/$maxW,($spec.H-4.0)/$maxH);$frames=@()
        for($c=0;$c -lt 4;$c++){$b=$bounds[$c];$frames+=,[WeaponSheet]::Frame($effects,$cells[$c],$scale,($b.Left+$b.Right)/2,($b.Top+$b.Bottom)/2,$spec.W,$spec.H,[int]($spec.W/2),[int]($spec.H/2),32)}
        $folder=if($r -eq 5){'folders/Спрайты/Items.yy'}else{'folders/Спрайты/Effects/Projectiles.yy'};$folderName=if($r -eq 5){'Items'}else{'Projectiles'}
        Sprite $spec.Name $frames 12 $spec.OX $spec.OY $folderName $folder
        foreach($im in $frames){$im.Dispose()}
    }
}finally{$effects.Dispose()}
Save-Json 'Young Poseidon.yyp' $project;Save-Json 'Young Poseidon.resource_order' $order
Save-Json 'tools/weapon_visuals_manifest.json' $manifest
