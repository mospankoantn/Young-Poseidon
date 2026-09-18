prop_draw_damage(hp,3);
if(prop_player_near(interact_range)) prop_hint(obj_player.current_weapon==2 ? lc("interact_break") : lc("need_pickaxe"),c_white);
