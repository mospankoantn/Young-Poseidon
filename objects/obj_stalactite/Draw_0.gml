var _shake = strike_flash > 0 ? sin(strike_flash * 2) * 3 : 0;
draw_sprite_ext(sprite_index,image_index,x+_shake,y,image_xscale,image_yscale,0,
    strike_flash > 10 ? make_color_rgb(255,220,170) : c_white,1);
if (strike_flash > 0) {
    draw_set_alpha(strike_flash/20);draw_set_color(make_color_rgb(214,201,177));
    for(var _i=0;_i<6;_i++) {
        var _t=20-strike_flash;
        var _dx=(bbox_left+bbox_right)*0.5+(_i-2.5)*_t*0.65;
        var _dy=bbox_bottom+_t*_t*0.07;
        draw_rectangle(_dx,_dy,_dx+3,_dy+3,false);
    }
    draw_set_alpha(1);draw_set_color(c_white);
}
if(prop_player_near(interact_range)) {
    var _text=obj_player.current_weapon==2 ? "["+yp_key_name("E")+"] "+yp_text("Розбити","Break") : lc("need_pickaxe");
    prop_hint(_text+" ("+string(stones_left)+"/4)",c_white);
}
