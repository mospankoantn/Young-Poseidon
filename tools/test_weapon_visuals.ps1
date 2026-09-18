$ErrorActionPreference='Stop'
& (Join-Path $PSScriptRoot 'test_player_death.ps1') -TestPrefix 'weapon_visuals' -SuccessMarker 'PASS: weapon visuals'
