# Player animation assets

The seven active clips are idle, run, jump, land, attack, hurt and death.
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
./tools/import_player_run_death.ps1
./tools/validate_player_animations.ps1
./tools/test_player_death.ps1
```

The importer is specific to the reviewed 1254x1254 source, not an arbitrary
grid slicer. It preserves existing frame identifiers where possible,
writes composite and layer PNGs, and updates sequence metadata.
The overlapping attack illustration is omitted: five attack frames and
six frames for idle/jump/land/hurt. The second importer replaces run with
eight frames and death with four: 41 active frames total.

All active frames are 128x96 with origin (64,88). Idle is 8 FPS, run 12,
landing 20, attack/hurt 18, death 6. Jump is selected by vertical velocity rather
than looping. Other imported poses are not connected to gameplay.

Validation covers YY/YYP parsing, resource links and versions, sprite
sequences, frame alpha, origins and End Step event registration.
The final project also passed GameMaker runtime-2026.0.0.23 Windows VM
compilation (successful load/link). The isolated GameMaker Runner test
checks every death frame, non-looping playback, input lock, facing, mask,
same-room and cross-room respawn, and game_restart without a checkpoint.
It copies the project to a fresh temporary directory and never edits
production rooms or saves.

## Revised run and death artwork

Prepared with the built-in image_gen tool. Source:
../Файли/player_run_death_source.png; preview:
../Файли/player_run_death_preview.png. Import uses a reviewed magenta key
and writes transparent 128x96 PNGs into the existing run/death resources.
The original six-row preview is retained as a historical source preview.

Initial prompt:

```text
Using the attached Young Poseidon character reference, create a corrected GAME SPRITE SHEET, 4 columns x 3 rows exactly, equal cells, 1024x768 canvas. Crisp pixel art matching the exact curly dark-blue-haired young boy with turquoise one-shoulder tunic and bare feet. All figures face RIGHT, consistent side view, body size and anchor. No labels, no grid lines, no scenery, no shadows. Use a solid flat pure magenta #FF00FF background for deterministic color-key import. No magenta in character. Every sprite isolated with generous empty space. Character approximately 150px tall standing, feet baseline at cell y=220, pelvis centered cell x=128. First EIGHT cells (row 1 then row 2) form ONE seamless complete RUN cycle, NOT a hop: 1 near-leg forward contact far-leg back, 2 near-leg weight-bearing down far-leg recovery, 3 near-leg back support far-leg passing forward, 4 far-leg forward reach near-leg lifting back, 5 FAR-leg forward contact NEAR-leg back, 6 far-leg weight-bearing down near-leg recovery, 7 far-leg back support near-leg passing forward, 8 near-leg forward reach far-leg lifting back. Near leg visibly lit, far leg shaded; arms counter-swing with legs, alternating support, minimal head bounce. Frame 8 loops seamlessly to frame 1. Last FOUR cells (row 3) DEATH once: 1 recoiling knees bending, 2 collapsing onto knees hand to ground, 3 falling on side, 4 fully lying still on ground head at right and feet left. Preserve size across death frames, ground baseline remains at y220, final lying figure must be fully inside cell. Do not repeat near-leg-only run poses. Do not include weapons, text, panels or extra body parts.
```

Pose refinement prompt:

```text
Correct ONLY the running poses in top two rows of this sprite sheet. Keep row 3 death poses unchanged, preserve magenta background, grid, hero identity, size and feet baselines. Current run repeats the same forward leg incorrectly. Produce a classical 8-frame SIDE VIEW running gait. Row1 frame1 near leg stretched FORWARD and far leg BACK; frame2 near planted under hips far knee swinging forward; frame3 NEAR LEG EXTENDED BACK and FAR LEG FORWARD (both visible separated, dark far leg); frame4 near knee recovering forward past far support leg. Row2 frame1 FAR LEG stretched FORWARD and NEAR LEG stretched BACK, opposite of row1frame1. Row2frame2 far planted under hips and near knee swinging forward. Row2frame3 far leg EXTENDED BACK and NEAR LEG FORWARD. Row2frame4 far knee recovering forward past near support leg. Left-right arms must alternate with legs. Make obvious foot positions alternate between wide stride and narrow passing stance. No hop on same leg. No duplicated poses. This is a contact/down/passing/up alternating gait diagram, NOT eight variants of same running pose. Keep very small body vertical bounce. Pixel art.
```

Final leg-shading correction prompt (the importer orders cells as
0, 1, 7, 6, 4, 5, 3, 2 to connect contact/support/passing/reach phases):

```text
Edit ONLY the top two running rows of the immediately preceding sprite sheet. Keep bottom death row pixel-identical, grid, body sizes, anchors, face, hair, torso unchanged and flat magenta background. Critical correction: in EVERY running cell of the SECOND ROW, the FORWARD leg (on right) must have DARK TAN SHADOWED skin, and the BACKWARD leg (on left) must have BRIGHT PEACH skin. Currently the forward leg is always bright and appears to be the same foot hopping. Reverse the leg shading in row 2 to visibly show the other leg leading. First row stays forward leg bright/back leg dark. Also vary foot spacing in each four-frame half-cycle: frame1 wide stride contact, frame2 planted leg under pelvis with opposite knee passing, frame3 trailing support foot under/behind pelvis with leading knee raised, frame4 wide airborne reach just before the opposite leg's contact. Row2 repeats these four phases with reversed near/far leg shading. No extra limbs, no shadow ground, no text. Keep the character recognizable, all right-facing. Make the second row DARK front leg explicit.
```
