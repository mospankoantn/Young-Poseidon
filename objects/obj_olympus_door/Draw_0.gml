var _open=is_open ? min(1,open_timer/30) : 0;
draw_sprite_ext(spr_olympus_door,0,x,y,image_xscale,image_yscale,0,c_white,1-_open);
if(_open>0) draw_sprite_ext(spr_olympus_door,1,x,y,image_xscale,image_yscale,0,c_white,_open);
if(!is_open && prop_player_near(interact_range))
    prop_hint(obj_player.has_olympus_key ? lc("interact_open") : lc("need_key"),c_white);
