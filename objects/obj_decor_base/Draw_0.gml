draw_set_alpha(0.65);
switch(zone) {
    case "coast":
        var _wing=sin(age*7+phase)*5;
        draw_set_color(make_color_rgb(242,242,225));
        draw_line_width(x-10,y-_wing,x,y+2,2);
        draw_line_width(x,y+2,x+10,y-_wing,2);
        draw_set_color(make_color_rgb(72,100,113));draw_line(x-2,y+2,x+2,y+2);
    break;
    case "mines":
        draw_set_color(make_color_rgb(148,188,202));
        draw_line(x,y-5,x,y+3);draw_rectangle(x-1,y+3,x+1,y+5,false);
    break;
    case "hades":
        draw_set_color(make_color_rgb(123,228,173));
        for(var _i=0;_i<4;_i++) {draw_set_alpha((4-_i)*0.12);draw_rectangle(x-_i*3,y+sin(age*3+_i)*3,x-_i*3+3,y+4+sin(age*3+_i)*3,false);}
    break;
    case "greece":
        draw_set_color(make_color_rgb(152,177,77));
        var _tilt=sin(age*3+phase)*5;
        draw_triangle(x-5,y,x+_tilt,y-4,x+5,y,false);
        draw_triangle(x-5,y,x-_tilt,y+4,x+5,y,false);
        draw_set_color(make_color_rgb(87,123,62));draw_line(x-4,y,x+4,y);
    break;
    case "battlefield":
        draw_set_color(make_color_rgb(247,160,85));
        draw_rectangle(x,y,x+2,y+3,false);
        draw_set_alpha(0.2);draw_line(x-5,y+4,x,y);
    break;
    case "olympus":
        draw_set_color(make_color_rgb(255,231,149));
        var _size=2+sin(age*2+phase);
        draw_line(x-_size,y,x+_size,y);draw_line(x,y-_size,x,y+_size);
    break;
}
draw_set_alpha(1);draw_set_color(c_white);
