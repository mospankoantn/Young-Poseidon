param([string]$ProjectRoot = (Split-Path $PSScriptRoot -Parent))
$ErrorActionPreference = 'Stop'

$projectPath = Join-Path $ProjectRoot 'Young Poseidon.yyp'
$orderPath = Join-Path $ProjectRoot 'Young Poseidon.resource_order'
$project = Get-Content -LiteralPath $projectPath -Raw | ConvertFrom-Json -Depth 100
$order = Get-Content -LiteralPath $orderPath -Raw | ConvertFrom-Json -Depth 100

$groups = [ordered]@{
    Bosses = @('Charon', 'Minotaur', 'Moirai', 'Nymph', 'Triton', 'Uranus', 'War Ghost')
    Enemies = @('Fallen Spirit', 'Giant Crab', 'Greek Warrior', 'Hades Shadow', 'Harpy Seagull', 'Miner Spirit', 'Olympus Fire')
    Player = @()
    World = @()
    Items = @()
    Weapons = @()
    UI = @()
    Effects = @()
}

$bossIds = @('charon', 'minotaur', 'moirai', 'nymph', 'triton', 'uranus', 'war_ghost')
$enemyIds = @('fallen_spirit', 'giant_crab', 'greek_warrior', 'hades_shadow', 'harpy_seagull', 'miner_spirit', 'olympus_fire')
$otherSprites = @{
    World = @('spr_fish_1', 'spr_fish_2', 'spr_platform', 'spr_sea_tiles', 'spr_thin_platform_sea')
    Items = @('spr_ambrosia', 'spr_amphora', 'spr_olympus_key', 'spr_potion_heal', 'spr_potion_speed', 'spr_potion_strength', 'spr_sandal')
    Weapons = @('spr_weapon_oar', 'spr_weapon_pickaxe', 'spr_weapon_scythe', 'spr_weapon_spear', 'spr_weapon_sword', 'spr_weapon_trident')
    UI = @('Menu_bg', 'spr_heart_empty', 'spr_heart_full')
    Effects = @('spr_bubble')
}

$folderPaths = @{}
$topOrder = 0
foreach ($group in $groups.Keys) {
    $topOrder++
    $folderPaths[$group] = "folders/Спрайты/$group.yy"
    $childOrder = 0
    foreach ($character in $groups[$group]) {
        $childOrder++
        $folderPaths["$group/$character"] = "folders/Спрайты/$group/$character.yy"
    }
}

$updates = @()
foreach ($resource in $project.resources) {
    if ($resource.id.path -notlike 'sprites/*') { continue }
    $spritePath = Join-Path $ProjectRoot $resource.id.path
    $sprite = Get-Content -LiteralPath $spritePath -Raw | ConvertFrom-Json -Depth 100
    $name = $sprite.name
    if ($sprite.parent.path -eq 'folders/Спрайты/Test.yy') { continue }

    $target = $null
    foreach ($id in $bossIds) {
        if ($name -match "^spr_boss_${id}_(idle|move|attack|death)$") {
            $target = 'Bosses/' + (Get-Culture).TextInfo.ToTitleCase($id.Replace('_', ' '))
            break
        }
    }
    if (-not $target) {
        foreach ($id in $enemyIds) {
            if ($name -eq "spr_$id" -and $id -eq 'giant_crab' -or $name -match "^spr_${id}_(idle|move|attack|death)$") {
                $target = 'Enemies/' + (Get-Culture).TextInfo.ToTitleCase($id.Replace('_', ' '))
                break
            }
        }
    }
    if (-not $target -and $name -match '^spr_player(_(attack|death|defend|emote|hurt|idle|interact|jump|land|pickup|run|swim|underwater|walk|water_attack))?$') {
        $target = 'Player'
    }
    if (-not $target) {
        foreach ($group in $otherSprites.Keys) {
            if ($name -cin $otherSprites[$group]) {
                $target = $group
                break
            }
        }
    }
    if (-not $target -or -not $folderPaths.ContainsKey($target)) {
        throw "Unmapped sprite: $name ($($resource.id.path))"
    }
    $leaf = ($target -split '/')[-1]
    $sprite.parent.name = $leaf
    $sprite.parent.path = $folderPaths[$target]
    $updates += [pscustomobject]@{ Path = $spritePath; Json = ($sprite | ConvertTo-Json -Depth 100) }
}

$topOrder = 0
foreach ($group in $groups.Keys) {
    $topOrder++
    $children = @($group)
    foreach ($character in $groups[$group]) { $children += "$group/$character" }
    $childOrder = 0
    foreach ($key in $children) {
        $folderPath = $folderPaths[$key]
        $leaf = ($key -split '/')[-1]
        $position = if ($key -eq $group) { $topOrder } else { ++$childOrder }
        if (-not @($project.Folders | Where-Object folderPath -eq $folderPath).Count) {
            $project.Folders += [pscustomobject][ordered]@{
                '$GMFolder' = ''
                '%Name' = $leaf
                folderPath = $folderPath
                name = $leaf
                resourceType = 'GMFolder'
                resourceVersion = '2.0'
            }
        }
        if (-not @($order.FolderOrderSettings | Where-Object path -eq $folderPath).Count) {
            $order.FolderOrderSettings += [pscustomobject][ordered]@{
                name = $leaf
                order = [int]$position
                path = $folderPath
            }
        }
    }
}

$utf8 = [Text.UTF8Encoding]::new($false)
foreach ($update in $updates) {
    [IO.File]::WriteAllText($update.Path, $update.Json + "`n", $utf8)
}
[IO.File]::WriteAllText($projectPath, ($project | ConvertTo-Json -Depth 100) + "`n", $utf8)
[IO.File]::WriteAllText($orderPath, ($order | ConvertTo-Json -Depth 100) + "`n", $utf8)
Write-Host "Organized $($updates.Count) sprite resources into $($folderPaths.Count) virtual folders."
