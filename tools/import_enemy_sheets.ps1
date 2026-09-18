param([string]$ProjectRoot = (Split-Path $PSScriptRoot -Parent))
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
Add-Type -ReferencedAssemblies System.Drawing,System.Drawing.Primitives,System.Drawing.Common -TypeDefinition @'
using System;
using System.Drawing;
using System.Drawing.Imaging;

public static class EnemySheet {
    static int Cut(Bitmap image, bool horizontal, int from, int to, int nominal, int otherFrom, int otherTo) {
        int best = nominal, fewest = int.MaxValue;
        for (int pos = from; pos <= to; pos++) {
            int count = 0;
            for (int other = otherFrom; other < otherTo; other += 3) {
                Color pixel = horizontal ? image.GetPixel(other, pos) : image.GetPixel(pos, other);
                if (pixel.A > 16) count++;
            }
            if (count < fewest || (count == fewest && Math.Abs(pos - nominal) < Math.Abs(best - nominal))) {
                fewest = count;
                best = pos;
            }
        }
        return best;
    }

    public static int[] RowCuts(Bitmap image) {
        return new int[] {
            0,
            Cut(image, true, 290, 400, 350, 0, image.Width),
            Cut(image, true, 570, 680, 625, 0, image.Width),
            Cut(image, true, 870, 1000, 935, 0, image.Width),
            image.Height
        };
    }

    public static int[] ColumnCuts(Bitmap image, int top, int bottom) {
        return new int[] {
            0,
            Cut(image, false, 255, 375, 313, top, bottom),
            Cut(image, false, 555, 700, 627, top, bottom),
            Cut(image, false, 860, 1030, 940, top, bottom),
            image.Width
        };
    }

    public static Rectangle Bounds(Bitmap image, Rectangle cell) {
        int minX = cell.Right, minY = cell.Bottom, maxX = cell.Left - 1, maxY = cell.Top - 1;
        for (int y = cell.Top; y < cell.Bottom; y++) {
            for (int x = cell.Left; x < cell.Right; x++) {
                if (image.GetPixel(x, y).A <= 16) continue;
                minX = Math.Min(minX, x); maxX = Math.Max(maxX, x);
                minY = Math.Min(minY, y); maxY = Math.Max(maxY, y);
            }
        }
        if (maxX < minX) throw new InvalidOperationException("Empty sprite cell: " + cell);
        return Rectangle.FromLTRB(minX, minY, maxX + 1, maxY + 1);
    }

    public static Bitmap Frame(Bitmap source, Rectangle cell, int baseline, double scale, int size) {
        Bitmap target = new Bitmap(size, size, PixelFormat.Format32bppArgb);
        double middle = (cell.Left + cell.Right) / 2.0;
        for (int y = 0; y < size; y++) {
            int sy = (int)Math.Floor((y - (size - 6)) / scale + baseline);
            if (sy < cell.Top || sy >= cell.Bottom) continue;
            for (int x = 0; x < size; x++) {
                int sx = (int)Math.Floor((x - size / 2.0) / scale + middle);
                if (sx < cell.Left || sx >= cell.Right) continue;
                Color pixel = source.GetPixel(sx, sy);
                if (pixel.A > 0) target.SetPixel(x, y, pixel);
            }
        }
        return target;
    }
}
'@

$items = @(
    @{Name='giant_crab'; Source='Спрайти Краба.png'; Size=96},
    @{Name='harpy_seagull'; Source='Sprites obj_harpy_seagull.png'; Size=96},
    @{Name='miner_spirit'; Source='Sprites obj_miner_spirit.png'; Size=96},
    @{Name='hades_shadow'; Source='Sprites obj_hades_shadow.png'; Size=96},
    @{Name='greek_warrior'; Source='Sprites obj_greek_warrior.png'; Size=96},
    @{Name='fallen_spirit'; Source='Sprites obj_fallen_spirit.png'; Size=96},
    @{Name='olympus_fire'; Source='Sprites obj_olympus_fire.png'; Size=96},
    @{Name='boss_triton'; Source='Sprites obj_boss_triton.png'; Size=192},
    @{Name='boss_nymph'; Source='Sprites obj_boss_nymph.png'; Size=192},
    @{Name='boss_uranus'; Source='Sprites obj_boss_uranus.png'; Size=192},
    @{Name='boss_charon'; Source='Sprites obj_boss_charon.png'; Size=192},
    @{Name='boss_minotaur'; Source='Sprites obj_boss_minotaur.png'; Size=192},
    @{Name='boss_war_ghost'; Source='Sprites obj_boss_war_ghost.png'; Size=192},
    @{Name='boss_moirai'; Source='Sprites obj_boss_moirai.png'; Size=192}
)
$states = @('idle','move','attack','death')
$fps = @(8,10,12,8)
$utf8 = [Text.UTF8Encoding]::new($false)
function Clone-Json($value) { return $value | ConvertTo-Json -Depth 100 | ConvertFrom-Json -Depth 100 }
function Save-Json($path,$value) { [IO.File]::WriteAllText($path,($value | ConvertTo-Json -Depth 100)+[char]10,$utf8) }

$template = Get-Content -LiteralPath (Join-Path $ProjectRoot 'sprites/spr_player_idle/spr_player_idle.yy') -Raw | ConvertFrom-Json -Depth 100
$scriptTemplate = Get-Content -LiteralPath (Join-Path $ProjectRoot 'scripts/scr_save_system/scr_save_system.yy') -Raw | ConvertFrom-Json -Depth 100
$projectPath = Join-Path $ProjectRoot 'Young Poseidon.yyp'
$orderPath = Join-Path $ProjectRoot 'Young Poseidon.resource_order'
$project = Get-Content -LiteralPath $projectPath -Raw | ConvertFrom-Json -Depth 100
$order = Get-Content -LiteralPath $orderPath -Raw | ConvertFrom-Json -Depth 100
$known=@{}
foreach($entry in $project.resources) {$known[$entry.id.name]=$entry.id.path}
$orderKnown=@{}
foreach($entry in $order.ResourceOrderSettings) {$orderKnown[$entry.name]=$true}
$nextOrder = [int](1 + (($order.ResourceOrderSettings | Where-Object {$_.path -like 'sprites/*'} | Measure-Object -Property order -Maximum).Maximum))

foreach($item in $items) {
    $sourcePath = Join-Path $ProjectRoot ('Файли/'+$item.Source)
    $source = [Drawing.Bitmap]::new($sourcePath)
    try {
        if($source.Width -ne 1254 -or $source.Height -ne 1254) {throw "Unexpected dimensions: $($item.Source)"}
        $rows=[EnemySheet]::RowCuts($source)
        $cells=@()
        $bounds=@()
        $maxWidth=0; $maxHeight=0
        $colsByRow=@()
        for($row=0;$row -lt 4;$row++) {
            $cols=[EnemySheet]::ColumnCuts($source,$rows[$row],$rows[$row+1])
            $colsByRow+=,$cols
            for($col=0;$col -lt 4;$col++) {
                $cell=[Drawing.Rectangle]::FromLTRB($cols[$col],$rows[$row],$cols[$col+1],$rows[$row+1])
                $bound=[EnemySheet]::Bounds($source,$cell)
                $cells+=,$cell; $bounds+=,$bound
                $maxWidth=[Math]::Max($maxWidth,$bound.Width)
                $maxHeight=[Math]::Max($maxHeight,$bound.Height)
            }
        }
        $size=$item.Size
        $scale=[Math]::Min(($size-10)/$maxWidth,($size-10)/$maxHeight)
        if($scale -le 0) {throw "Invalid image scale: $($item.Source)"}
        for($row=0;$row -lt 4;$row++) {
            $name='spr_'+$item.Name+'_'+$states[$row]
            $relative="sprites/$name/$name.yy"
            $dir=Join-Path $ProjectRoot ('sprites/'+$name)
            [IO.Directory]::CreateDirectory($dir) | Out-Null
            $yyPath=Join-Path $dir ($name+'.yy')
            if(Test-Path -LiteralPath $yyPath) {
                $yy=Get-Content -LiteralPath $yyPath -Raw | ConvertFrom-Json -Depth 100
                $oldFrames=@($yy.frames)
                $oldKeys=@($yy.sequence.tracks[0].keyframes.Keyframes)
                $layerId=$yy.layers[0].name
            } else {
                $yy=Clone-Json $template
                $oldFrames=@(); $oldKeys=@()
                $layerId=[guid]::NewGuid().ToString()
            }
            $yy.name=$name; $yy.'%Name'=$name
            $yy.width=$size; $yy.height=$size
            $yy.bboxMode=2; $yy.bbox_left=0; $yy.bbox_top=0
            $yy.bbox_right=$size-1; $yy.bbox_bottom=$size-1
            $yy.origin=9
            $yy.sequence.name=$name; $yy.sequence.'%Name'=$name
            $yy.sequence.length=4.0
            $yy.sequence.xorigin=$size/2; $yy.sequence.yorigin=$size-6
            $yy.sequence.playbackSpeed=[double]$fps[$row]
            $yy.sequence.playbackSpeedType=0
            $yy.layers[0].name=$layerId; $yy.layers[0].'%Name'=$layerId
            $newFrames=@();$newKeys=@()
            $baseline=($bounds[($row*4)..($row*4+3)] | Measure-Object -Property Bottom -Maximum).Maximum
            for($col=0;$col -lt 4;$col++) {
                $frame=Clone-Json $template.frames[0]
                $key=Clone-Json $template.sequence.tracks[0].keyframes.Keyframes[0]
                $frameId=if($col -lt $oldFrames.Count){$oldFrames[$col].name}else{[guid]::NewGuid().ToString()}
                $keyId=if($col -lt $oldKeys.Count){$oldKeys[$col].id}else{[guid]::NewGuid().ToString()}
                $frame.name=$frameId; $frame.'%Name'=$frameId
                $key.id=$keyId; $key.Key=[double]$col
                $key.Channels.'0'.Id.name=$frameId
                $key.Channels.'0'.Id.path=$relative
                $newFrames+=,$frame; $newKeys+=,$key
                $i=$row*4+$col
                $bitmap=[EnemySheet]::Frame($source,$cells[$i],$baseline,$scale,$size)
                try {
                    $png=Join-Path $dir ($frameId+'.png')
                    $bitmap.Save($png,[Drawing.Imaging.ImageFormat]::Png)
                    $layerDir=Join-Path $dir ('layers/'+$frameId)
                    [IO.Directory]::CreateDirectory($layerDir) | Out-Null
                    Copy-Item -LiteralPath $png -Destination (Join-Path $layerDir ($layerId+'.png')) -Force
                } finally {$bitmap.Dispose()}
            }
            $yy.frames=$newFrames
            $yy.sequence.tracks[0].keyframes.Keyframes=$newKeys
            Save-Json $yyPath $yy
            if($known.ContainsKey($name) -and $known[$name] -ne $relative){throw "Conflicting resource name: $name"}
            if(!$known.ContainsKey($name)) {
                $project.resources+= [PSCustomObject]@{id=[PSCustomObject]@{name=$name;path=$relative}}
                $known[$name]=$relative
            }
            if(!$orderKnown.ContainsKey($name)) {
                $order.ResourceOrderSettings+= [PSCustomObject]@{name=$name;order=[int]$nextOrder;path=$relative}
                $orderKnown[$name]=$true; $nextOrder++
            }
        }
        $objectName='obj_'+$item.Name
        $objectPath=Join-Path $ProjectRoot ("objects/$objectName/$objectName.yy")
        $object=Get-Content -LiteralPath $objectPath -Raw | ConvertFrom-Json -Depth 100
        $idle='spr_'+$item.Name+'_idle'
        $object.spriteId=[PSCustomObject]@{name=$idle;path="sprites/$idle/$idle.yy"}
        $object.spriteMaskId=[PSCustomObject]@{name='spr_giant_crab';path='sprites/spr_giant_crab/spr_giant_crab.yy'}
        $endSteps=@($object.eventList | Where-Object {$_.eventType -eq 3 -and $_.eventNum -eq 2})
        if($endSteps.Count -eq 0) {
            $event=Clone-Json ((Get-Content -LiteralPath (Join-Path $ProjectRoot 'objects/obj_player/obj_player.yy') -Raw | ConvertFrom-Json -Depth 100).eventList | Where-Object {$_.eventType -eq 3 -and $_.eventNum -eq 2} | Select-Object -First 1)
            $object.eventList+=,$event
        }
        Save-Json $objectPath $object
        Write-Output "$($item.Source) => $objectName, cuts Y=$($rows -join ','), $size px, 4x4 frames"
    } finally {$source.Dispose()}
}
$scriptName='scr_enemy_animation'
$scriptRelative="scripts/$scriptName/$scriptName.yy"
$scriptDir=Join-Path $ProjectRoot ('scripts/'+$scriptName)
[IO.Directory]::CreateDirectory($scriptDir) | Out-Null
$script=Clone-Json $scriptTemplate
$script.name=$scriptName; $script.'%Name'=$scriptName
Save-Json (Join-Path $scriptDir ($scriptName+'.yy')) $script
if(!$known.ContainsKey($scriptName)) {
    $project.resources+= [PSCustomObject]@{id=[PSCustomObject]@{name=$scriptName;path=$scriptRelative}}
    $known[$scriptName]=$scriptRelative
}
if(!$orderKnown.ContainsKey($scriptName)) {
    $order.ResourceOrderSettings+= [PSCustomObject]@{name=$scriptName;order=1;path=$scriptRelative}
}
Save-Json $projectPath $project
Save-Json $orderPath $order
