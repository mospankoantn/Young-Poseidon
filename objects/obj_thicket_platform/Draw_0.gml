draw_sprite_ext(spr_thicket_platform,0,x,y,image_xscale,image_yscale,0,image_blend,image_alpha);
if(!is_cutting && prop_player_near(interact_range))
    prop_hint(obj_player.current_weapon==3 ? lc("interact_cut") : lc("need_scythe"),c_white);
