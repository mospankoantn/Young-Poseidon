# Player animation assets

The six active clips are idle, run, jump, land, attack and hurt.
They reuse the existing spr_player_* resource names. Gameplay keeps
spr_player as its collision mask.

## Artwork

The original reference is the supplied Young Poseidon sheet in the
project's Ukrainian-named assets folder. The built-in image_gen tool
prepared a cleaner six-row variant; no API/CLI fallback was used.
A follow-up background-removal edit still returned a painted background,
so the importer removes edge-connected neutral pixels and writes real alpha.

Selected source: ../Файли/player_animation_source.png
Reviewed contact sheet: ../Файли/player_animation_preview.png
GameMaker assets: ../sprites/spr_player_{idle,run,jump,land,attack,hurt}/

Generation prompt:

```text
Edit the attached Young Poseidon pixel-art character sprite sheet into a production-ready transparent sprite sheet for a GameMaker game. Preserve this exact young hero design: curly dark navy-blue hair, youthful face, bare arms, teal/turquoise Greek tunic with one shoulder exposed, bare feet, right-facing side/three-quarter view, crisp detailed pixel art. Output ONE square 1536x1536 RGBA image with genuinely TRANSPARENT background (no painted checkerboard). Exact regular 6 columns x 6 rows grid, equal 256x256 cells, NO labels, NO borders, NO panels, NO floor, NO shadows, NO scenery. Six frames in each row from left to right. Each character has consistent proportions and scale with standing height approximately 170 pixels, head/body centered near x=128 of its cell; feet baseline y=220 per cell, with generous padding for weapons. Row 1: IDLE breathing, 6 subtle looping frames. Row 2: RUN, 6 distinct phases of rightward running loop with alternating legs and arms. Row 3: JUMP, 6 phases from takeoff to rising to apex to falling; pose changes but character feet consistently anchored at y=220 (vertical displacement is handled by the game). Row 4: LANDING, 6 phases from deep crouched landing to upright neutral idle, feet anchored to same baseline. Row 5: ATTACK, 6 phases of a rightward golden trident thrust/throw windup, extension, release and recovery. Show one slender trident and a small cyan splash only, never duplicate bodies in one cell, keep weapons/effects fully inside each cell. Row 6: HURT, 6 phases of flinch/recoil and recovery back to standing; NOT death, no collapse to lying down. Every cell must contain exactly ONE complete isolated character, with no pieces of neighbor frames or overlap across grid boundaries. All sprites face RIGHT. The attachment is reference for identity/style and motions; improve consistency and clean silhouettes. Output image only.
```

## Reimport and validation

Run from the project root in PowerShell 7 (System.Drawing on Windows):

```powershell
./tools/import_player_animations.ps1 -Source './Файли/player_animation_source.png'
./tools/validate_player_animations.ps1
```

The importer is specific to the reviewed 1254x1254 source, not an arbitrary
grid slicer. It preserves existing frame identifiers where possible,
writes composite and layer PNGs, and updates sequence metadata.
The overlapping attack illustration is omitted: five attack frames and
six frames for each other active state, 35 frames total.

All active frames are 128x96 with origin (64,88). Idle is 8 FPS, run 12,
landing 20, attack/hurt 18. Jump is selected by vertical velocity rather
than looping. Other imported poses are not connected to gameplay.

Validation covers YY/YYP parsing, resource links and versions, sprite
sequences, frame alpha, origins and End Step event registration.
The final project also passed GameMaker runtime-2026.0.0.23 Windows VM
compilation (successful load/link). Interactive gameplay was not tested.

