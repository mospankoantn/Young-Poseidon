/// @description 
/// obj_raft — Draw Event

draw_self();
 
// Підказка якщо гравець стоїть на плоту без весла
if (has_player && obj_player.current_weapon != 4)
{
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_alpha(0.75);
    draw_set_color(c_ltgray);
    if (font_exists(fnt_main)) draw_set_font(fnt_main);
    draw_text(x, y - sprite_height / 2 - 10, "Потрібне весло");
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_set_font(-1);
}