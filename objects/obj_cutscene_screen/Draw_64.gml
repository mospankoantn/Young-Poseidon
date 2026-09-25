/// Full-bleed illustration with a measured, readable caption band.
if(!is_array(pages)||array_length(pages)==0) exit;
var _gw=display_get_gui_width(),_gh=display_get_gui_height();
var _p=pages[clamp(page_index,0,array_length(pages)-1)];
draw_set_alpha(fade_alpha);draw_set_color(c_black);draw_rectangle(0,0,_gw,_gh,false);
if(sprite_exists(_p.sprite)) {
    var _s=max(_gw/sprite_get_width(_p.sprite),(_gh-155)/sprite_get_height(_p.sprite));
    var _w=sprite_get_width(_p.sprite)*_s,_h=sprite_get_height(_p.sprite)*_s;
    draw_sprite_stretched(_p.sprite,0,(_gw-_w)/2,0,_w,_h);
}
var _top=_gh-210;
draw_set_color(make_color_rgb(7,17,24));draw_set_alpha(fade_alpha*0.96);
draw_rectangle(0,_top,_gw,_gh,false);
draw_set_alpha(fade_alpha);draw_set_color(make_color_rgb(233,193,109));
draw_rectangle(36,_top+1,_gw-36,_top+3,false);
draw_set_halign(fa_left);draw_set_valign(fa_top);draw_set_font(fnt_title);
var _title=lc(_p.title_key);
var _title_scale=min(1,(_gw-72)/max(1,string_width(_title)));
draw_text_transformed(36,_top+16,_title,_title_scale,_title_scale,0);
draw_set_font(fnt_main);draw_set_color(make_color_rgb(229,237,236));
var _body=lc(_p.body_key),_body_scale=1;
while(string_height_ext(_body,20,(_gw-72)/_body_scale)*_body_scale>104 && _body_scale>0.72) _body_scale-=0.04;
draw_text_ext_transformed(36,_top+57,_body,20,(_gw-72)/_body_scale,_body_scale,_body_scale,0);
draw_set_halign(fa_right);draw_set_color(make_color_rgb(239,206,139));
draw_text(_gw-36,_gh-29,lc(page_index+1<array_length(pages)?"cutscene_continue":"cutscene_close"));
draw_set_halign(fa_left);draw_set_color(make_color_rgb(153,183,187));
draw_text(36,_gh-29,string(page_index+1)+" / "+string(array_length(pages)));
draw_set_font(-1);draw_set_valign(fa_top);draw_set_alpha(1);draw_set_color(c_white);
yp_draw_cursor();
