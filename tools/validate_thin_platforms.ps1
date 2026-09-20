param(
    [string]$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
)

$ErrorActionPreference = "Stop"

$create = Get-Content -Raw -Encoding UTF8 (Join-Path $ProjectRoot "objects/obj_player/Create_0.gml")
$step   = Get-Content -Raw -Encoding UTF8 (Join-Path $ProjectRoot "objects/obj_player/Step_0.gml")
$end    = Get-Content -Raw -Encoding UTF8 (Join-Path $ProjectRoot "objects/obj_player/Step_2.gml")

$checks = @(
    @{ Name = "solid/thin separation helper"; Pass = $create.Contains("_meets_solid_platform") },
    @{ Name = "support snap helper"; Pass = $create.Contains("_find_platform_support_y") },
    @{ Name = "solid top support helper"; Pass = $create.Contains("_is_standing_on_solid_platform") },
    @{ Name = "thin surface support helper"; Pass = $create.Contains("_is_standing_on_thin_platform") },
    @{ Name = "swept solid landing helper"; Pass = $create.Contains("_solid_landing_y") },
    @{ Name = "spawn overlap recovery helper"; Pass = $create.Contains("_recover_solid_overlap_y") -and $step.Contains("_spawn_recover_y") },
    @{ Name = "swept top-crossing landing helper"; Pass = $create.Contains("_thin_landing_y") -and -not $create.Contains("if (!place_meeting(x, _next_y, obj_thin_platform))") },
    @{ Name = "horizontal motion ignores thin"; Pass = $step.Contains("_meets_solid_platform(x + _h_step, y)") },
    @{ Name = "drop requires thin without solid"; Pass = $step.Contains("_drop && _on_thin && !_on_solid") },
    @{ Name = "grounded character is pinned before gravity"; Pass = $step.Contains("y = _solid_support_y") -and $step.Contains("y = _thin_support_y") },
    @{ Name = "gravity only applies in air"; Pass = $step.Contains("if (!_on_ground && !_jumped_this_step)") },
    @{ Name = "solid priority in vertical motion"; Pass = $step.Contains("_solid_landing_y(_next_y)") -and $step.Contains("_meets_solid_platform(x, _next_y)") },
    @{ Name = "solid landing ends drop-through"; Pass = $step.Contains("_on_solid = true") -and $step.Contains("drop_timer = 0") },
    @{ Name = "post-horizontal solid probe ignores drop timer"; Pass = $step.Contains("if (vspd >= 0)") -and $step.Contains("_solid_support_after_x") },
    @{ Name = "final post-vertical ground reconciliation"; Pass = $step.Contains("_solid_support_final") -and $step.Contains("_thin_support_final") },
    @{ Name = "shared grounded state for physics and animation"; Pass = $create.Contains("grounded = false") -and $step.Contains("grounded = _on_ground") -and $end.Contains("grounded && vspd == 0") },
    @{ Name = "thin landing only while falling"; Pass = $step.Contains("if (_v_step > 0)") -and $step.Contains("if (drop_timer <= 0)") -and $step.Contains("_thin_landing_y(_next_y)") },
    @{ Name = "solid ground ignores thin drop timer"; Pass = $end.Contains("_is_standing_on_solid_platform()") -and $end.Contains("drop_timer <= 0 && _is_standing_on_thin_platform()") }
)

$failed = @($checks | Where-Object { -not $_.Pass })
foreach ($check in $checks) {
    $prefix = if ($check.Pass) { "[OK]" } else { "[FAIL]" }
    Write-Host "$prefix $($check.Name)"
}

if ($failed.Count -gt 0) {
    throw "Thin-platform validation failed: $($failed.Count) check(s)."
}

Write-Host "Thin-platform static validation passed."
