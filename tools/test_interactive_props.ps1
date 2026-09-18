$ErrorActionPreference='Stop'
& (Join-Path $PSScriptRoot 'test_player_death.ps1') -TestPrefix 'interactive_props' -SuccessMarker 'PASS: interactive props'
