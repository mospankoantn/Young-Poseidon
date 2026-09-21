import os
import re
import uuid
import json
from PIL import Image, ImageDraw, ImageFilter, ImageEnhance

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def get_guid():
    return str(uuid.uuid4())

def add_vignette_and_frame(im):
    w, h = im.size
    overlay = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)
    
    # Outer dark border
    draw.rectangle([0, 0, w - 1, h - 1], outline=(10, 20, 35, 255), width=2)
    # Golden inner accent
    draw.rectangle([2, 2, w - 3, h - 3], outline=(212, 175, 55, 180), width=1)
    
    # Corner ornaments (Greek style small brackets)
    corner_size = 12
    # Top-left
    draw.line([(4, 4), (4 + corner_size, 4)], fill=(244, 188, 74, 255), width=2)
    draw.line([(4, 4), (4, 4 + corner_size)], fill=(244, 188, 74, 255), width=2)
    # Top-right
    draw.line([(w - 5 - corner_size, 4), (w - 5, 4)], fill=(244, 188, 74, 255), width=2)
    draw.line([(w - 5, 4), (w - 5, 4 + corner_size)], fill=(244, 188, 74, 255), width=2)
    # Bottom-left
    draw.line([(4, h - 5), (4 + corner_size, h - 5)], fill=(244, 188, 74, 255), width=2)
    draw.line([(4, h - 5 - corner_size), (4, h - 5)], fill=(244, 188, 74, 255), width=2)
    # Bottom-right
    draw.line([(w - 5 - corner_size, h - 5), (w - 5, h - 5)], fill=(244, 188, 74, 255), width=2)
    draw.line([(w - 5, h - 5 - corner_size), (w - 5, h - 5)], fill=(244, 188, 74, 255), width=2)

    return Image.alpha_composite(im.convert("RGBA"), overlay)

def create_cutscenes():
    os.chdir(BASE_DIR)
    
    menu_bg = Image.open("Файли/Графіка/Меню/Menu_background_clean.png").convert("RGBA")
    tiles_ref = Image.open("Файли/Графіка/Референси/Gemini_Generated_Image_5ivcf5ivcf5ivcf5.png").convert("RGBA")
    
    cutscenes = {}

    # 1. INTRO
    # Wide panoramic crop showing Poseidon looking to Olympus
    intro = menu_bg.crop((200, 300, 1536, 1024)).resize((480, 270), Image.Resampling.LANCZOS)
    cutscenes["spr_cutscene_intro"] = add_vignette_and_frame(intro)

    # 2. OUTRO
    # Olympus summit bathed in divine golden light with Poseidon
    outro_base = menu_bg.crop((850, 0, 1536, 650)).resize((480, 270), Image.Resampling.LANCZOS)
    enhancer = ImageEnhance.Color(outro_base)
    outro_base = enhancer.enhance(1.2)
    # Add warm golden divine aura
    gold_overlay = Image.new("RGBA", (480, 270), (255, 215, 0, 35))
    outro = Image.alpha_composite(outro_base, gold_overlay)
    cutscenes["spr_cutscene_outro"] = add_vignette_and_frame(outro)

    # 3. 7 BIOMES
    # In Gemini_Generated_Image_5ivcf5ivcf5ivcf5.png, panel width is ~418, height 326 (top 45 is header)
    panel_w = tiles_ref.width / 7.0
    biome_names = ["sea", "coast", "mines", "hades", "greece", "battlefield", "olympus"]
    
    # Atmospheric colors for biomes
    biome_tints = [
        (0, 140, 200, 40),    # sea: deep turquoise
        (220, 180, 90, 35),   # coast: sunny sand
        (50, 60, 75, 50),     # mines: stone twilight
        (20, 70, 40, 55),     # hades: toxic underworld
        (70, 140, 220, 35),   # greece: azure sky
        (180, 40, 30, 45),    # battlefield: blood dusk
        (255, 230, 140, 45)   # olympus: divine radiant
    ]

    for i, name in enumerate(biome_names):
        x1 = int(i * panel_w)
        x2 = int((i + 1) * panel_w)
        crop_box = (x1 + 4, 45, x2 - 4, tiles_ref.height - 4)
        panel = tiles_ref.crop(crop_box).resize((480, 270), Image.Resampling.LANCZOS)
        
        # Add subtle atmospheric tint
        tint = Image.new("RGBA", (480, 270), biome_tints[i])
        panel = Image.alpha_composite(panel, tint)
        cutscenes[f"spr_cutscene_{name}"] = add_vignette_and_frame(panel)

    # 4. 7 BOSS WEAPON REWARDS
    # We compose each weapon on a stylized pedestal / energy aura
    weapon_sources = {
        "trident": ("Файли/Графіка/Зброя/Sprite examples trident.png", (0, 180, 240)),
        "spear":   ("Файли/Графіка/Зброя/Sprite examples spear.png", (100, 220, 150)),
        "pickaxe": ("Файли/Графіка/Зброя/Sprite examples pickaxe .png", (240, 170, 60)),
        "scythe":  ("Файли/Графіка/Зброя/Sprite examples scythe.png", (160, 80, 220)),
        "oar":     ("Файли/Графіка/Зброя/Sprite examples oar.png", (70, 160, 240)),
        "sword":   ("Файли/Графіка/Зброя/Sprite examples sword.png", (240, 80, 60)),
    }

    for weapon, (path, aura_col) in weapon_sources.items():
        base = Image.new("RGBA", (480, 270), (12, 18, 30, 255))
        draw = ImageDraw.Draw(base)
        
        # Radial background gradient circles
        cx, cy = 240, 135
        for r in range(120, 0, -5):
            alpha = int((1.0 - (r / 120.0)) * 60)
            col = (aura_col[0], aura_col[1], aura_col[2], alpha)
            draw.ellipse([cx - r, cy - r, cx + r, cy + r], fill=col)

        # Load weapon sprite sheet and crop single main frame
        w_img = Image.open(path).convert("RGBA")
        bbox = w_img.getbbox()
        if bbox:
            wc = w_img.crop((0, 0, min(600, w_img.width), min(600, w_img.height)))
            w_bbox = wc.getbbox()
            if w_bbox:
                wc = wc.crop(w_bbox)
            wc.thumbnail((200, 200), Image.Resampling.LANCZOS)
            wx = cx - wc.width // 2
            wy = cy - wc.height // 2
            
            glow = Image.new("RGBA", base.size, (0, 0, 0, 0))
            gdraw = ImageDraw.Draw(glow)
            gdraw.ellipse([wx - 10, wy - 10, wx + wc.width + 10, wy + wc.height + 10], 
                          fill=(aura_col[0], aura_col[1], aura_col[2], 100))
            glow = glow.filter(ImageFilter.GaussianBlur(12))
            base = Image.alpha_composite(base, glow)
            base.paste(wc, (wx, wy), wc)
            
        cutscenes[f"spr_cutscene_{weapon}"] = add_vignette_and_frame(base)

    # 5. OLYMPUS KEY REWARD
    key_base = Image.new("RGBA", (480, 270), (18, 14, 32, 255))
    draw = ImageDraw.Draw(key_base)
    cx, cy = 240, 135
    for r in range(130, 0, -5):
        alpha = int((1.0 - (r / 130.0)) * 75)
        draw.ellipse([cx - r, cy - r, cx + r, cy + r], fill=(255, 215, 60, alpha))
        
    key_file = "sprites/spr_olympus_key"
    if os.path.exists(key_file):
        for f in os.listdir(key_file):
            if f.endswith(".png") and not f.startswith("."):
                key_img = Image.open(os.path.join(key_file, f)).convert("RGBA")
                key_img = key_img.resize((160, 160), Image.Resampling.NEAREST)
                kx = cx - key_img.width // 2
                ky = cy - key_img.height // 2
                key_base.paste(key_img, (kx, ky), key_img)
                break
                
    cutscenes["spr_cutscene_key"] = add_vignette_and_frame(key_base)

    return cutscenes

def register_sprites(cutscenes):
    with open("Young Poseidon.yyp", "r", encoding="utf-8") as f:
        yyp_text = f.read()
    
    cleaned_yyp = re.sub(r',\s*([\]\}])', r'\1', yyp_text)
    yyp_data = json.loads(cleaned_yyp)

    with open("Young Poseidon.resource_order", "r", encoding="utf-8") as f:
        order_text = f.read()
    cleaned_order = re.sub(r',\s*([\]\}])', r'\1', order_text)
    order_data = json.loads(cleaned_order)

    existing_resources = {r["id"]["name"]: r for r in yyp_data["resources"]}
    existing_orders = {r["name"]: r for r in order_data["ResourceOrderSettings"]}

    order_idx = max([r.get("order", 0) for r in order_data["ResourceOrderSettings"]] + [0]) + 1

    for spr_name, img in cutscenes.items():
        spr_dir = os.path.join("sprites", spr_name)
        os.makedirs(spr_dir, exist_ok=True)
        
        frame_id = get_guid()
        layer_id = get_guid()
        keyframe_id = get_guid()

        layers_dir = os.path.join(spr_dir, "layers", frame_id)
        os.makedirs(layers_dir, exist_ok=True)
        
        composite_path = os.path.join(spr_dir, f"{frame_id}.png")
        layer_path = os.path.join(layers_dir, f"{layer_id}.png")
        
        img.save(composite_path, "PNG")
        img.save(layer_path, "PNG")

        yy_content = {
            "$GMSprite": "v2",
            "%Name": spr_name,
            "bboxMode": 0,
            "bbox_bottom": img.height - 1,
            "bbox_left": 0,
            "bbox_right": img.width - 1,
            "bbox_top": 0,
            "collisionKind": 1,
            "collisionTolerance": 0,
            "DynamicTexturePage": False,
            "edgeFiltering": False,
            "For3D": False,
            "frames": [
                {
                    "$GMSpriteFrame": "v1",
                    "%Name": frame_id,
                    "name": frame_id,
                    "resourceType": "GMSpriteFrame",
                    "resourceVersion": "2.0"
                }
            ],
            "gridX": 0,
            "gridY": 0,
            "height": img.height,
            "HTile": False,
            "layers": [
                {
                    "$GMImageLayer": "",
                    "%Name": layer_id,
                    "blendMode": 0,
                    "displayName": "default",
                    "isLocked": False,
                    "name": layer_id,
                    "opacity": 100.0,
                    "resourceType": "GMImageLayer",
                    "resourceVersion": "2.0",
                    "visible": True
                }
            ],
            "name": spr_name,
            "nineSlice": None,
            "origin": 0,
            "parent": {
                "name": "UI",
                "path": "folders/Спрайты/UI.yy"
            },
            "preMultiplyAlpha": False,
            "resourceType": "GMSprite",
            "resourceVersion": "2.0",
            "sequence": {
                "$GMSequence": "v1",
                "%Name": spr_name,
                "autoRecord": True,
                "backdropHeight": 768,
                "backdropImageOpacity": 0.5,
                "backdropImagePath": "",
                "backdropWidth": 1366,
                "backdropXOffset": 0.0,
                "backdropYOffset": 0.0,
                "events": {
                    "$KeyframeStore<MessageEventKeyframe>": "",
                    "Keyframes": [],
                    "resourceType": "KeyframeStore<MessageEventKeyframe>",
                    "resourceVersion": "2.0"
                },
                "eventStubScript": None,
                "eventToFunction": {},
                "length": 1.0,
                "lockOrigin": False,
                "moments": {
                    "$KeyframeStore<MomentsEventKeyframe>": "",
                    "Keyframes": [],
                    "resourceType": "KeyframeStore<MomentsEventKeyframe>",
                    "resourceVersion": "2.0"
                },
                "name": spr_name,
                "playback": 1,
                "playbackSpeed": 30.0,
                "playbackSpeedType": 0,
                "resourceType": "GMSequence",
                "resourceVersion": "2.0",
                "showBackdrop": True,
                "showBackdropImage": False,
                "timeUnits": 1,
                "tracks": [
                    {
                        "$GMSpriteFramesTrack": "",
                        "builtinName": 0,
                        "events": [],
                        "inheritsTrackColour": True,
                        "interpolation": 1,
                        "isCreationTrack": False,
                        "keyframes": {
                            "$KeyframeStore<SpriteFrameKeyframe>": "",
                            "Keyframes": [
                                {
                                    "$Keyframe<SpriteFrameKeyframe>": "",
                                    "Channels": {
                                        "0": {
                                            "$SpriteFrameKeyframe": "",
                                            "Id": {
                                                "name": frame_id,
                                                "path": f"sprites/{spr_name}/{spr_name}.yy"
                                            },
                                            "resourceType": "SpriteFrameKeyframe",
                                            "resourceVersion": "2.0"
                                        }
                                    },
                                    "Disabled": False,
                                    "id": keyframe_id,
                                    "IsCreationKey": False,
                                    "Key": 0.0,
                                    "Length": 1.0,
                                    "resourceType": "Keyframe<SpriteFrameKeyframe>",
                                    "resourceVersion": "2.0",
                                    "Stretch": False
                                }
                            ],
                            "resourceType": "KeyframeStore<SpriteFrameKeyframe>",
                            "resourceVersion": "2.0"
                        },
                        "modifiers": [],
                        "name": "frames",
                        "resourceType": "GMSpriteFramesTrack",
                        "resourceVersion": "2.0",
                        "spriteId": None,
                        "trackColour": 0,
                        "tracks": [],
                        "traits": 0
                    }
                ],
                "visibleRange": None,
                "volume": 1.0,
                "xorigin": 0,
                "yorigin": 0
            },
            "swatchColours": None,
            "swfPrecision": 0.5,
            "textureGroupId": {
                "name": "Default",
                "path": "texturegroups/Default"
            },
            "type": 0,
            "VTile": False,
            "width": img.width
        }

        with open(os.path.join(spr_dir, f"{spr_name}.yy"), "w", encoding="utf-8") as f:
            json.dump(yy_content, f, indent=2, ensure_ascii=False)

        if spr_name not in existing_resources:
            yyp_data["resources"].append({
                "id": {
                    "name": spr_name,
                    "path": f"sprites/{spr_name}/{spr_name}.yy"
                }
            })
            existing_resources[spr_name] = True
            print(f"Registered sprite in YYP: {spr_name}")

        if spr_name not in existing_orders:
            order_data["ResourceOrderSettings"].append({
                "name": spr_name,
                "order": order_idx,
                "path": f"sprites/{spr_name}/{spr_name}.yy"
            })
            order_idx += 1
            existing_orders[spr_name] = True
            print(f"Registered sprite in resource_order: {spr_name}")

    with open("Young Poseidon.yyp", "w", encoding="utf-8") as f:
        json.dump(yyp_data, f, indent=2, ensure_ascii=False)

    with open("Young Poseidon.resource_order", "w", encoding="utf-8") as f:
        json.dump(order_data, f, indent=2, ensure_ascii=False)

if __name__ == "__main__":
    print("Building cutscene graphics...")
    cutscenes = create_cutscenes()
    print(f"Generated {len(cutscenes)} cutscene images.")
    register_sprites(cutscenes)
    print("All cutscenes created and registered successfully.")
