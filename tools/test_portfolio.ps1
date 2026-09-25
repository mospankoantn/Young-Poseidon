$ErrorActionPreference='Stop'
& (Join-Path $PSScriptRoot 'test_player_death.ps1') -TestPrefix 'portfolio' -SuccessMarker 'PASS: PORTFOLIO COMBAT TESTS'
