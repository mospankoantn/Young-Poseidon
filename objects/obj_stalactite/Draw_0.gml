draw_self();
if(prop_player_near(interact_range)) {
    var _text=obj_player.current_weapon==2 ? "["+yp_key_name("E")+"] "+yp_text("Розбити","Break") : lc("need_pickaxe");
    prop_hint(_text+" ("+string(stones_left)+"/4)",c_white);
}
