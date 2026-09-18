if(!gallery) exit;
draw_set_color(make_color_rgb(24,48,57));draw_rectangle(0,0,960,640,false);
var _sprites=[spr_falling_rocks,spr_falling_stone,spr_interactive_button,spr_mine_cart,spr_minotaur_column,spr_olympus_door,spr_raft,spr_rail,spr_stalactite,spr_stone_boulder,spr_thicket_platform,spr_uranus_barrier,spr_checkpoint];
draw_set_font(fnt_main);draw_set_halign(fa_center);draw_set_valign(fa_top);
for(var _i=0;_i<array_length(_sprites);_i++){
    var _s=_sprites[_i],_xx=120+(_i mod 4)*240,_yy=20+(_i div 4)*155;
    var _scale=min(2,min(190/sprite_get_width(_s),115/sprite_get_height(_s)));
    draw_sprite_ext(_s,0,_xx-sprite_get_width(_s)*_scale/2+sprite_get_xoffset(_s)*_scale,_yy+sprite_get_yoffset(_s)*_scale,_scale,_scale,0,c_white,1);
    draw_set_color(c_white);draw_text(_xx,_yy+119,string_replace(sprite_get_name(_s),"spr_",""));
}
if(tick==22) screen_save(report_path+".png");
draw_set_halign(fa_left);draw_set_valign(fa_top);draw_set_font(-1);
