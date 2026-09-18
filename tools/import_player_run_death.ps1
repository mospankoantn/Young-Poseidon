param(
    [string]$Source = (Join-Path (Split-Path $PSScriptRoot -Parent) 'Файли/player_run_death_source.png'),
    [string]$ProjectRoot = (Split-Path $PSScriptRoot -Parent)
)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
Add-Type -ReferencedAssemblies System.Drawing,System.Drawing.Primitives,System.Drawing.Common -TypeDefinition @'
using System;
using System.Drawing;
using System.Drawing.Imaging;
public static class RunDeathFrames {
    public static Bitmap Cut(Bitmap src, int cell, int anchorX, int feetY) {
        int left=(cell%4)*362, top=(cell/4)*362;
        Bitmap result=new Bitmap(128,96,PixelFormat.Format32bppArgb);
        for(int y=0;y<96;y++) for(int x=0;x<128;x++) {
            int sx=(int)Math.Floor((x-64)/0.264+anchorX);
            int sy=(int)Math.Floor((y-88)/0.264+feetY);
            if(sx<left||sx>=left+362||sy<top||sy>=top+362) continue;
            if(cell==9 && sx>680) continue;
            Color p=src.GetPixel(sx,sy);
            // The reviewed source uses magenta exclusively as a background key.
            if(p.R>150 && p.B>150 && p.G<100) continue;
            result.SetPixel(x,y,p);
        }
        return result;
    }
}
'@
$sourceImage=[System.Drawing.Bitmap]::new((Resolve-Path -LiteralPath $Source).Path)
if($sourceImage.Width -ne 1448 -or $sourceImage.Height -ne 1086) {throw 'Review crop positions before importing a different sheet.'}
$specs=@(
    # Contact, support, passing, opposite reach; then the other half-stride.
    @{Name='run'; FPS=12; Cells=@(0,1,7,6,4,5,3,2); Anchors=@(176,534,1260,899,175,537,1256,897); Feet=@(331,331,677,677,677,677,331,331)},
    @{Name='death'; FPS=6; Cells=@(8,9,10,11); Anchors=@(175,534,899,1256); Feet=@(1007,1007,1007,1007)}
)
$preview=[System.Drawing.Bitmap]::new(8*128,2*112)
$graphics=[System.Drawing.Graphics]::FromImage($preview)
$graphics.Clear([System.Drawing.Color]::FromArgb(44,56,60))
$font=[System.Drawing.Font]::new('Consolas',10)
$utf8=[System.Text.UTF8Encoding]::new($false)
for($row=0;$row -lt $specs.Count;$row++) {
    $spec=$specs[$row]
    $name='spr_player_'+$spec.Name
    $dir=Join-Path $ProjectRoot "sprites/$name"
    $yyPath=Join-Path $dir "$name.yy"
    $yy=Get-Content -LiteralPath $yyPath -Raw -Encoding utf8 | ConvertFrom-Json -Depth 100
    $oldFrames=@($yy.frames)
    $oldKeys=@($yy.sequence.tracks[0].keyframes.Keyframes)
    $frames=@()
    $keys=@()
    for($i=0;$i -lt $spec.Cells.Count;$i++) {
        $frame=$oldFrames[[Math]::Min($i,$oldFrames.Count-1)] | ConvertTo-Json -Depth 100 | ConvertFrom-Json -Depth 100
        $key=$oldKeys[[Math]::Min($i,$oldKeys.Count-1)] | ConvertTo-Json -Depth 100 | ConvertFrom-Json -Depth 100
        if($i -ge $oldFrames.Count) {
            $frame.name=[guid]::NewGuid().ToString()
            $frame.'%Name'=$frame.name
            $key.id=[guid]::NewGuid().ToString()
        }
        $key.Key=[double]$i
        $key.Channels.'0'.Id.name=$frame.name
        $key.Channels.'0'.Id.path="sprites/$name/$name.yy"
        $frames+=,$frame
        $keys+=,$key
        $bitmap=[RunDeathFrames]::Cut($sourceImage,$spec.Cells[$i],$spec.Anchors[$i],$spec.Feet[$i])
        $png=Join-Path $dir ($frame.name+'.png')
        $layerDir=Join-Path $dir ('layers/'+$frame.name)
        [IO.Directory]::CreateDirectory($layerDir) | Out-Null
        $bitmap.Save($png,[System.Drawing.Imaging.ImageFormat]::Png)
        Copy-Item -LiteralPath $png -Destination (Join-Path $layerDir ($yy.layers[0].name+'.png')) -Force
        $graphics.DrawImageUnscaled($bitmap,$i*128,$row*112+16)
        $bitmap.Dispose()
    }
    $yy.frames=$frames
    $yy.width=128; $yy.height=96; $yy.origin=9; $yy.bboxMode=2
    $yy.bbox_left=40; $yy.bbox_right=88; $yy.bbox_top=24; $yy.bbox_bottom=87
    $yy.sequence.xorigin=64; $yy.sequence.yorigin=88
    $yy.sequence.length=[double]$frames.Count
    $yy.sequence.playbackSpeed=[double]$spec.FPS
    $yy.sequence.playbackSpeedType=0
    $yy.sequence.tracks[0].keyframes.Keyframes=$keys
    [IO.File]::WriteAllText($yyPath,($yy | ConvertTo-Json -Depth 100)+[char]10,$utf8)
    $graphics.DrawString($spec.Name,$font,[System.Drawing.Brushes]::White,4,$row*112)
    Write-Output "$name : $($frames.Count) frames, $($spec.FPS) fps, origin 64/88"
}
$preview.Save((Join-Path $ProjectRoot 'Файли/player_run_death_preview.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$font.Dispose(); $graphics.Dispose(); $preview.Dispose(); $sourceImage.Dispose()
