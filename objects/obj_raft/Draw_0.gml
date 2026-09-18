draw_self();
if(has_player && instance_exists(obj_player) && obj_player.current_weapon!=4)
    prop_hint(yp_text("Потрібне весло","Equip the oar"),c_white);
