$ErrorActionPreference='Stop'
& (Join-Path $PSScriptRoot 'test_menu_settings.ps1') -TestPrefix 'presentation' -SuccessMarker 'PASS: WORLD PRESENTATION TESTS'
