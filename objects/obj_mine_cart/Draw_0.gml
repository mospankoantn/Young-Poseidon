draw_self();
if(prop_player_near(interact_range))
    prop_hint("["+yp_key_name("E")+"] "+(has_player ? yp_text("Вийти","Exit") : yp_text("Сісти у вагонетку","Enter cart")),c_white);
