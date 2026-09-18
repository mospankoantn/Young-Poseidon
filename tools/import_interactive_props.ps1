param([string]$Source='')
$ErrorActionPreference='Stop'
$root=Split-Path $PSScriptRoot -Parent
if(!$Source){$Source=Join-Path $root 'Файли/Графіка/Інтерактивні об''єкти/interactive_props_source.png'}
Add-Type -AssemblyName System.Drawing
$utf8=[Text.UTF8Encoding]::new($false)
function ReadJ($p){Get-Content -LiteralPath (Join-Path $root $p) -Raw|ConvertFrom-Json -Depth 100}
function Clone($o){$o|ConvertTo-Json -Depth 100|ConvertFrom-Json -Depth 100}
function SaveJ($p,$o){[IO.File]::WriteAllText((Join-Path $root $p),($o|ConvertTo-Json -Depth 100)+"`n",$utf8)}
$dest=Join-Path $root 'Файли/Графіка/Інтерактивні об''єкти/interactive_props_source.png'
if([IO.Path]::GetFullPath($Source) -ne [IO.Path]::GetFullPath($dest)){Copy-Item -LiteralPath $Source -Destination $dest -Force}
$atlas=[Drawing.Bitmap]::new($Source)
if($atlas.Width -ne 1536 -or $atlas.Height -ne 1024){throw 'Unexpected atlas dimensions'}
# Coordinates checked against the actual image: the door and shrine cross nominal row boundaries.
$rects=@(@(0,0,384,245),@(384,0,384,245),@(768,0,384,245),@(1152,0,384,245),
@(0,245,384,250),@(384,245,384,255),@(768,245,384,255),@(1152,245,384,255),
@(0,495,384,255),@(384,500,384,245),@(768,500,384,245),@(1152,500,384,248),
@(0,750,384,274),@(384,750,384,274),@(768,750,384,274),@(1152,748,384,276))
Add-Type -ReferencedAssemblies System.Drawing,System.Drawing.Primitives,System.Drawing.Common -TypeDefinition @'
using System;
using System.Drawing;
public static class PropAtlas {
 public static bool Key(Color c) {return c.R>100 && c.B>100 && c.G<Math.Min(c.R,c.B)*0.65;}
 public static Bitmap Frame(Bitmap src,Rectangle cell,int w,int h) {
  int l=cell.Right,t=cell.Bottom,r=cell.Left,b=cell.Top;
  for(int y=cell.Top;y<cell.Bottom;y++) for(int x=cell.Left;x<cell.Right;x++) {
   var c=src.GetPixel(x,y); if(c.A>32&&!Key(c)){l=Math.Min(l,x);t=Math.Min(t,y);r=Math.Max(r,x);b=Math.Max(b,y);}
  }
  if(r<=l||b<=t)throw new Exception("Empty sprite crop");
  var output=new Bitmap(w,h);
  for(int y=2;y<h-2;y++)for(int x=2;x<w-2;x++){
   int sx=l+(x-2)*(r-l+1)/(w-4),sy=t+(y-2)*(b-t+1)/(h-4);
   var c=src.GetPixel(sx,sy); if(!Key(c))output.SetPixel(x,y,c);
  }
  return output;
 }
}
'@
$template=ReadJ 'sprites/spr_player_idle/spr_player_idle.yy'
$project=ReadJ 'Young Poseidon.yyp'
$order=ReadJ 'Young Poseidon.resource_order'
$folder='folders/Спрайты/Interactive.yy'
if($folder -notin $project.Folders.folderPath){
 $project.Folders+= [pscustomobject]@{'$GMFolder'='';'%Name'='Interactive';folderPath=$folder;name='Interactive';resourceType='GMFolder';resourceVersion='2.0'}
 $order.FolderOrderSettings+= [pscustomobject]@{name='Interactive';order=12;path=$folder}
}
$spec=@(
@('falling_rocks',48,40,0,0,@(0,1),''),
@('falling_stone',32,32,0,0,@(0,1),''),
@('interactive_button',64,64,0,0,@(2,3),'spr_button_test'),
@('mine_cart',64,64,0,0,@(4),'spr_test_64'),
@('minotaur_column',64,64,0,0,@(5,6),'spr_test_64'),
@('olympus_door',32,64,0,0,@(7,8),'spr_door_test'),
@('raft',164,28,0,0,@(9),'spr_platform'),
@('rail',164,18,0,0,@(10),'spr_platform'),
@('stalactite',64,64,0,0,@(11),'spr_test_64'),
@('stone_boulder',64,64,0,0,@(12),'spr_test_64'),
@('thicket_platform',164,64,0,54,@(13),'spr_platform'),
@('uranus_barrier',64,64,0,0,@(14),'spr_test_64'),
@('checkpoint',64,64,0,0,@(15),'spr_test_64'))
foreach($item in $spec){
 $name='spr_'+$item[0]; $relative="sprites/$name/$name.yy"; $dir=Join-Path $root "sprites/$name"
 [IO.Directory]::CreateDirectory($dir)|Out-Null
 $exists=Test-Path (Join-Path $root $relative)
 $s=if($exists){ReadJ $relative}else{Clone $template}
 $oldframes=if($exists){@($s.frames)}else{@()};$oldkeys=if($exists){@($s.sequence.tracks[0].keyframes.Keyframes)}else{@()}
 $s.name=$name;$s.'%Name'=$name;$s.width=$item[1];$s.height=$item[2]
 $s.origin=9;$s.sequence.xorigin=$item[3];$s.sequence.yorigin=$item[4]
 $s.bboxMode=2;$s.bbox_left=3;$s.bbox_top=3;$s.bbox_right=$s.width-4;$s.bbox_bottom=$s.height-4
 $s.parent.name='Interactive';$s.parent.path=$folder
 $s.sequence.name=$name;$s.sequence.'%Name'=$name;$s.sequence.length=[double]$item[5].Count;$s.sequence.playbackSpeed=0.0
 $s.sequence.backdropWidth=$s.width;$s.sequence.backdropHeight=$s.height
 $layer=if($exists){$s.layers[0].name}else{[guid]::NewGuid().ToString()}
 $s.layers[0].name=$layer;$s.layers[0].'%Name'=$layer
 $s.frames=@();$s.sequence.tracks[0].keyframes.Keyframes=@()
 for($i=0;$i -lt $item[5].Count;$i++){
  $fid=if($i -lt $oldframes.Count){$oldframes[$i].name}else{[guid]::NewGuid().ToString()}
  $f=Clone $template.frames[0];$f.name=$fid;$f.'%Name'=$fid;$s.frames+=,$f
  $k=Clone $template.sequence.tracks[0].keyframes.Keyframes[0]
  $k.id=if($i -lt $oldkeys.Count){$oldkeys[$i].id}else{[guid]::NewGuid().ToString()}
  $k.Key=[double]$i;$k.Length=1.0;$k.Channels.'0'.Id.name=$fid;$k.Channels.'0'.Id.path=$relative
  $s.sequence.tracks[0].keyframes.Keyframes+=,$k
  $r=$rects[$item[5][$i]]
  $img=[PropAtlas]::Frame($atlas,[Drawing.Rectangle]::new($r[0],$r[1],$r[2],$r[3]),$s.width,$s.height)
  $png=Join-Path $dir "$fid.png";$img.Save($png,[Drawing.Imaging.ImageFormat]::Png);$img.Dispose()
  $ld=Join-Path $dir "layers/$fid";[IO.Directory]::CreateDirectory($ld)|Out-Null
  Copy-Item -LiteralPath $png -Destination (Join-Path $ld "$layer.png") -Force
 }
 SaveJ $relative $s
 if($name -notin $project.resources.id.name){$project.resources+=[pscustomobject]@{id=[pscustomobject]@{name=$name;path=$relative}}}
 if($name -notin $order.ResourceOrderSettings.name){$order.ResourceOrderSettings+=[pscustomobject]@{name=$name;path=$relative;order=$order.ResourceOrderSettings.Count}}
 $op="objects/obj_$($item[0])/obj_$($item[0]).yy";$o=ReadJ $op
 $o.spriteId=[pscustomobject]@{name=$name;path=$relative}
 if($item[6]){$o.spriteMaskId=[pscustomobject]@{name=$item[6];path="sprites/$($item[6])/$($item[6]).yy"}}
 if($item[0] -in @('falling_rocks','falling_stone')){$o.parentObjectId=$null;$o.spriteMaskId=$null}
 if($item[0] -eq 'olympus_door'){$o.parentObjectId=[pscustomobject]@{name='obj_platform';path='objects/obj_platform/obj_platform.yy'}}
 if($item[0] -eq 'raft'){$o.parentObjectId=[pscustomobject]@{name='obj_thin_platform';path='objects/obj_thin_platform/obj_thin_platform.yy'}}
 SaveJ $op $o
}
$atlas.Dispose()
# Preserve compact project formatting, add only the missing folder/resource entries.
$projectText=[IO.File]::ReadAllText((Join-Path $root 'Young Poseidon.yyp'))
foreach($entry in $project.resources){
 if(!$projectText.Contains('"name":"'+$entry.id.name+'"') -and !$projectText.Contains('"name": "'+$entry.id.name+'"')){
  $line=($entry|ConvertTo-Json -Depth 10 -Compress)+','
  $projectText=$projectText.Replace('"resources":[','"resources":['+"`n    "+$line)
 }
}
if(!$projectText.Contains($folder)){
 $entry=$project.Folders|Where-Object folderPath -eq $folder
 $projectText=$projectText.Replace('"Folders":[','"Folders":['+"`n    "+($entry|ConvertTo-Json -Compress)+',')
}
[IO.File]::WriteAllText((Join-Path $root 'Young Poseidon.yyp'),$projectText,$utf8)
SaveJ 'Young Poseidon.resource_order' $order
Write-Output 'Imported 13 interactive sprites; preserved existing obstacle masks, removed platform parent from falling debris.'
