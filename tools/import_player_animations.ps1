param(
    [Parameter(Mandatory=$true)][string]$Source,
    [string]$ProjectRoot = (Split-Path $PSScriptRoot -Parent)
)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
Add-Type -ReferencedAssemblies System.Drawing,System.Drawing.Primitives,System.Drawing.Common -TypeDefinition @'
using System;
using System.Drawing;
using System.Drawing.Imaging;
public static class PoseidonFrames {
    // Only neutral background connected to the crop boundary is removed.
    public static Bitmap Cut(Bitmap source, int left, int top, int right, int bottom,
                             int anchorX, int feetY) {
        int w=right-left, h=bottom-top;
        bool[] seen=new bool[w*h];
        int[] queue=new int[w*h];
        int head=0, tail=0;
        for(int y=0;y<h;y++) for(int x=0;x<w;x++) {
            if(x!=0 && y!=0 && x!=w-1 && y!=h-1) continue;
            Color p=source.GetPixel(left+x,top+y);
            int max=Math.Max(p.R,Math.Max(p.G,p.B)), min=Math.Min(p.R,Math.Min(p.G,p.B));
            if(p.A==0 || (max-min<32 && min>75)) {
                int i=y*w+x; if(!seen[i]) {seen[i]=true;queue[tail++]=i;}
            }
        }
        while(head<tail) {
            int i=queue[head++], x=i%w,y=i/w;
            for(int d=0;d<4;d++) {
                int nx=x+(d==0?-1:d==1?1:0), ny=y+(d==2?-1:d==3?1:0);
                if(nx<0||ny<0||nx>=w||ny>=h)continue;
                int n=ny*w+nx;if(seen[n])continue;
                Color p=source.GetPixel(left+nx,top+ny);
                int max=Math.Max(p.R,Math.Max(p.G,p.B)), min=Math.Min(p.R,Math.Min(p.G,p.B));
                if(p.A==0 || (max-min<32 && min>75)) {seen[n]=true;queue[tail++]=n;}
            }
        }
        Bitmap result=new Bitmap(128,96,PixelFormat.Format32bppArgb);
        const double scale=0.35;
        for(int y=0;y<96;y++)for(int x=0;x<128;x++){
            int sx=(int)Math.Floor((x-64)/scale+anchorX);
            int sy=(int)Math.Floor((y-88)/scale+feetY);
            if(sx<left||sy<top||sx>=right||sy>=bottom)continue;
            if(seen[(sy-top)*w+sx-left])continue;
            result.SetPixel(x,y,source.GetPixel(sx,sy));
        }
        return result;
    }
}
'@
$sourceImage = [System.Drawing.Bitmap]::new((Resolve-Path -LiteralPath $Source).Path)
if ($sourceImage.Width -ne 1254 -or $sourceImage.Height -ne 1254) {
    throw 'Expected the reviewed 1254x1254 sheet; review crop coordinates before importing another sheet.'
}
$specs = @(
    @{ Name='idle'; FPS=8; Top=20; Bottom=231; Feet=221; Cuts=@(0,209,418,627,836,1045,1254); Anchors=@(120,329,538,747,956,1165) },
    @{ Name='run'; FPS=12; Top=234; Bottom=440; Feet=433; Cuts=@(0,209,418,627,836,1045,1254); Anchors=@(125,334,543,752,961,1170) },
    @{ Name='jump'; FPS=12; Top=445; Bottom=682; Feet=672; Cuts=@(0,209,423,629,835,1045,1254); Anchors=@(126,335,544,753,962,1171);
       FrameFeet=@(673,670,635,620,659,672) },
    @{ Name='land'; FPS=20; Top=686; Bottom=885; Feet=876; Cuts=@(0,209,418,632,836,1045,1254); Anchors=@(123,332,541,750,959,1168) },
    # The release illustration overlaps its neighbour and is omitted.
    @{ Name='attack'; FPS=18; Top=887; Bottom=1076; Feet=1068;
       Boxes=@(@(0,214),@(215,425),@(426,652),@(895,1080),@(1080,1254)); Anchors=@(123,333,504,954,1163) },
    @{ Name='hurt'; FPS=18; Top=1077; Bottom=1254; Feet=1244;
       Boxes=@(@(0,220),@(250,418),@(418,630),@(630,836),@(836,1045),@(1045,1254)); Anchors=@(126,335,544,753,962,1171) }
)
$preview = [System.Drawing.Bitmap]::new(6*128,6*112)
$graphics = [System.Drawing.Graphics]::FromImage($preview)
$graphics.Clear([System.Drawing.Color]::FromArgb(44,56,60))
$font = [System.Drawing.Font]::new('Consolas',10)
$utf8 = [System.Text.UTF8Encoding]::new($false)
for ($row=0;$row -lt $specs.Count;$row++) {
    $spec=$specs[$row]
    $name='spr_player_'+$spec.Name
    $dir=Join-Path $ProjectRoot "sprites/$name"
    $yyPath=Join-Path $dir "$name.yy"
    $yy=Get-Content -LiteralPath $yyPath -Raw -Encoding utf8 | ConvertFrom-Json -Depth 100
    $oldFrames=@($yy.frames)
    $layer=$yy.layers[0].name
    $frames=@()
    $keys=@()
    $count=$spec.Anchors.Count
    $keyTemplate=$yy.sequence.tracks[0].keyframes.Keyframes[0] | ConvertTo-Json -Depth 100
    for($col=0;$col -lt $count;$col++) {
        if($col -lt $oldFrames.Count) {$frame=$oldFrames[$col]}
        else {
            $frame=$oldFrames[0] | ConvertTo-Json -Depth 10 | ConvertFrom-Json
            $frame.name=[guid]::NewGuid().ToString()
            $frame.'%Name'=$frame.name
        }
        $frames+=,$frame
        if($spec.ContainsKey('Boxes')) {$left=$spec.Boxes[$col][0];$right=$spec.Boxes[$col][1]}
        else {$left=$spec.Cuts[$col];$right=$spec.Cuts[$col+1]}
        $feet=if($spec.ContainsKey('FrameFeet')) {$spec.FrameFeet[$col]} else {$spec.Feet}
        $bitmap=[PoseidonFrames]::Cut($sourceImage,$left,$spec.Top,$right,$spec.Bottom,$spec.Anchors[$col],$feet)
        if ($spec.Name -eq 'attack' -and $col -eq 2) {
            # The neighbouring pose starts below the extended trident tip.
            for ($py=65;$py -lt 96;$py++) {
                for ($px=107;$px -lt 128;$px++) {
                    $bitmap.SetPixel($px,$py,[System.Drawing.Color]::Transparent)
                }
            }
        }
        $png=Join-Path $dir ($frame.name+'.png')
        $layerDir=Join-Path $dir ('layers/'+$frame.name)
        [IO.Directory]::CreateDirectory($layerDir) | Out-Null
        $bitmap.Save($png,[System.Drawing.Imaging.ImageFormat]::Png)
        Copy-Item -LiteralPath $png -Destination (Join-Path $layerDir ($layer+'.png')) -Force
        $graphics.DrawImageUnscaled($bitmap,$col*128,$row*112+16)
        $bitmap.Dispose()
        $key=$keyTemplate | ConvertFrom-Json -Depth 100
        $key.id=if($col -lt $yy.sequence.tracks[0].keyframes.Keyframes.Count) {
            $yy.sequence.tracks[0].keyframes.Keyframes[$col].id
        } else {[guid]::NewGuid().ToString()}
        $key.Key=[double]$col
        $key.Channels.'0'.Id.name=$frame.name
        $key.Channels.'0'.Id.path="sprites/$name/$name.yy"
        $keys+=,$key
    }
    $yy.frames=$frames
    $yy.width=128
    $yy.height=96
    $yy.origin=9
    $yy.bboxMode=2
    $yy.bbox_left=40
    $yy.bbox_right=88
    $yy.bbox_top=24
    $yy.bbox_bottom=87
    $yy.sequence.xorigin=64
    $yy.sequence.yorigin=88
    $yy.sequence.length=[double]$count
    $yy.sequence.playbackSpeed=[double]$spec.FPS
    $yy.sequence.playbackSpeedType=0
    $yy.sequence.tracks[0].keyframes.Keyframes=$keys
    [IO.File]::WriteAllText($yyPath,($yy | ConvertTo-Json -Depth 100)+[char]10,$utf8)
    $graphics.DrawString($spec.Name,$font,[System.Drawing.Brushes]::White,4,$row*112)
    Write-Output "$name : $count frames, $($spec.FPS) fps, 128x96, origin 64/88"
}
$assetDir=Join-Path $ProjectRoot 'Файли'
$sourceTarget=Join-Path $assetDir 'player_animation_source.png'
if ([IO.Path]::GetFullPath($Source) -ne [IO.Path]::GetFullPath($sourceTarget)) {
    Copy-Item -LiteralPath $Source -Destination $sourceTarget -Force
}
$preview.Save((Join-Path $assetDir 'player_animation_preview.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$font.Dispose()
$graphics.Dispose()
$preview.Dispose()
$sourceImage.Dispose()
