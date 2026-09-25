param([string]$ProjectRoot=(Split-Path $PSScriptRoot -Parent))
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'import_portfolio_assets.ps1') -ProjectRoot $ProjectRoot
$source=Join-Path $ProjectRoot 'Файли/Графіка/Полірування/zone_background_atlas.png'
if(!(Test-Path -LiteralPath $source)) {
    Copy-Item -LiteralPath 'C:/Users/Олег/.codex/generated_images/019dc5ef-83e1-7023-9d86-20a2ac4a60a3/exec-7e7e2c9e-eef4-40fa-8a53-903d8c591626.png' -Destination $source
}
$atlas=[Drawing.Bitmap]::new($source)
try {
    $zones=@('coast','mines','hades','greece','battlefield','olympus')
    for($i=0;$i -lt 6;$i++) {
        $cw=[int]($atlas.Width/2);$ch=[int]($atlas.Height/3)
        $rect=[Drawing.Rectangle]::new(($i%2)*$cw,[int][Math]::Floor($i/2)*$ch,$cw,$ch)
        $part=$atlas.Clone($rect,[Drawing.Imaging.PixelFormat]::Format32bppArgb)
        try { Save-Sprite "spr_background_$($zones[$i])" $part }
        finally {$part.Dispose()}
    }
} finally {$atlas.Dispose()}
$name='obj_zone_background';$relative="objects/$name/$name.yy"
$obj=Clone (Read-Json 'objects/obj_decor_base/obj_decor_base.yy')
$obj.name=$name;$obj.'%Name'=$name;$obj.eventList=@((Event 8 0))
Save-Json $relative $obj;Register $name $relative
Save-Json 'Young Poseidon.yyp' $project
Save-Json 'Young Poseidon.resource_order' $order
Write-Output 'Imported six 3:2 biome panoramas and their non-colliding background object.'
