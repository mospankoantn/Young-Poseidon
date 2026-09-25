/// Startup screens share hit geometry with Step.
var _gw=display_get_gui_width(), _gh=display_get_gui_height();
if (startup_state=="logo") {
    draw_set_alpha(1);draw_set_color(make_color_rgb(6,12,17));
    draw_rectangle(0,0,_gw,_gh,false);
    var _a=clamp((startup_logo_age-4)/25,0,1);
    var _scale=min((_gw-160)/sprite_get_width(spr_logo_eclipse_wire),180/sprite_get_height(spr_logo_eclipse_wire));
    draw_sprite_ext(spr_logo_eclipse_wire,0,_gw*0.5,_gh*0.44,_scale,_scale,0,c_white,_a);
    draw_set_font(fnt_main);draw_set_halign(fa_center);draw_set_valign(fa_middle);
    draw_set_alpha(_a);draw_set_color(make_color_rgb(189,208,212));
    draw_text(_gw*0.5,_gh*0.66,"YOUNG POSEIDON");
    draw_set_alpha(startup_logo_prompt_alpha);draw_set_color(make_color_rgb(140,160,169));
    draw_text(_gw*0.5,_gh-44,yp_text("Пропустити","Skip")+"  [Enter]");
} else if(startup_state=="language") {
    draw_set_alpha(1);draw_set_color(c_white);
    draw_sprite_stretched(Menu_bg,0,0,0,_gw,_gh);
    draw_set_alpha(0.82);draw_set_color(make_color_rgb(6,17,24));
    draw_rectangle(0,0,_gw,_gh,false);draw_set_alpha(1);
    draw_set_halign(fa_center);draw_set_valign(fa_middle);
    draw_set_font(fnt_title);draw_set_color(make_color_rgb(247,213,139));
    draw_text(_gw/2,86,"Young Poseidon");
    draw_set_font(fnt_main);draw_set_color(c_white);
    draw_text(_gw/2,142,"Оберіть мову / Choose language");
    for(var _i=0;_i<2;_i++) {
        var _r=startup_language_rect(_i);
        var _selected=startup_lang_selected==_i;
        draw_set_alpha(0.9);draw_set_color(make_color_rgb(13,31,39));
        draw_rectangle(_r[0],_r[1],_r[2],_r[3],false);draw_set_alpha(1);
        draw_set_color(_selected?make_color_rgb(246,207,122):make_color_rgb(77,104,113));
        draw_rectangle(_r[0],_r[1],_r[2],_r[3],true);
        if(_selected) draw_rectangle(_r[0],_r[3]-3,_r[2],_r[3],false);
        var _cx=(_r[0]+_r[2])/2,_cy=_r[1]+48;
        if(_i==0) {
            draw_set_color(make_color_rgb(37,112,217));draw_rectangle(_cx-34,_cy-22,_cx+34,_cy,false);
            draw_set_color(make_color_rgb(255,211,68));draw_rectangle(_cx-34,_cy,_cx+34,_cy+22,false);
        } else {
            draw_set_color(make_color_rgb(38,64,116));draw_rectangle(_cx-34,_cy-22,_cx+34,_cy+22,false);
            draw_set_color(c_white);
            draw_line_width(_cx-30,_cy-19,_cx+30,_cy+19,7);
            draw_line_width(_cx-30,_cy+19,_cx+30,_cy-19,7);
            draw_rectangle(_cx-7,_cy-22,_cx+7,_cy+22,false);draw_rectangle(_cx-34,_cy-6,_cx+34,_cy+6,false);
            draw_set_color(make_color_rgb(202,47,57));
            draw_rectangle(_cx-3,_cy-22,_cx+3,_cy+22,false);draw_rectangle(_cx-34,_cy-3,_cx+34,_cy+3,false);
        }
        draw_set_color(c_white);draw_text(_cx,_r[3]-32,_i==0?"Українська":"English");
    }
    draw_set_color(make_color_rgb(186,205,211));
    draw_text(_gw/2,_gh-80,"Enter");
    draw_set_color(make_color_rgb(129,158,165));
    draw_text(_gw/2,_gh-43,"Українська / English");
} else yp_menu_draw();
draw_set_alpha(1);draw_set_color(c_white);
draw_set_font(-1);draw_set_halign(fa_left);draw_set_valign(fa_top);
if(startup_transition_alpha>0) {
    draw_set_alpha(startup_transition_alpha);draw_set_color(c_black);
    draw_rectangle(0,0,_gw,_gh,false);
    draw_set_alpha(1);draw_set_color(c_white);
}
yp_draw_cursor();
