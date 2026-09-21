/// @description Greek-styled modal cutscene UI.
if (!is_array(pages) || array_length(pages) <= 0) exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _page = pages[clamp(page_index, 0, array_length(pages) - 1)];

// Full-screen dimmer.
draw_set_alpha(0.94 * fade_alpha);
draw_set_color(make_color_rgb(3, 8, 18));
draw_rectangle(0, 0, _gw, _gh, false);

var _margin_x = max(22, _gw * 0.045);
var _margin_y = max(22, _gh * 0.065);
var _panel_x1 = _margin_x;
var _panel_y1 = _margin_y;
var _panel_x2 = _gw - _margin_x;
var _panel_y2 = _gh - _margin_y;
var _panel_w = _panel_x2 - _panel_x1;
var _panel_h = _panel_y2 - _panel_y1;

// Main stone/navy panel and gold Greek frame.
draw_set_alpha(0.98 * fade_alpha);
draw_set_color(make_color_rgb(10, 20, 36));
draw_rectangle(_panel_x1, _panel_y1, _panel_x2, _panel_y2, false);
draw_set_color(make_color_rgb(220, 176, 67));
draw_rectangle(_panel_x1, _panel_y1, _panel_x2, _panel_y2, true);
draw_rectangle(_panel_x1 + 5, _panel_y1 + 5, _panel_x2 - 5, _panel_y2 - 5, true);

// Small meander-like corner accents.
var _orn = min(36, _panel_w * 0.04);
draw_line(_panel_x1 + 10, _panel_y1 + 14, _panel_x1 + 10 + _orn, _panel_y1 + 14);
draw_line(_panel_x1 + 10, _panel_y1 + 14, _panel_x1 + 10, _panel_y1 + 14 + _orn);
draw_line(_panel_x2 - 10 - _orn, _panel_y1 + 14, _panel_x2 - 10, _panel_y1 + 14);
draw_line(_panel_x2 - 10, _panel_y1 + 14, _panel_x2 - 10, _panel_y1 + 14 + _orn);

var _inner = max(18, _panel_w * 0.022);
var _content_x = _panel_x1 + _inner;
var _content_y = _panel_y1 + _inner;
var _content_w = _panel_w - _inner * 2;
var _footer_h = max(34, _panel_h * 0.08);
var _usable_bottom = _panel_y2 - _inner - _footer_h;

// On smaller GUI sizes reserve more room for text; on wider screens use a
// balanced illustration/text split.
var _img_ratio = (_gw < 900) ? 0.38 : 0.43;
var _img_w = _content_w * _img_ratio;
var _img_h = min((_usable_bottom - _content_y) * 0.72, _img_w * 270 / 480);
var _img_x = _content_x;
var _img_y = _content_y + max(10, ((_usable_bottom - _content_y) - _img_h) * 0.46);

if (_page.sprite >= 0 && sprite_exists(_page.sprite))
{
    draw_set_alpha(fade_alpha);
    draw_set_color(c_white);
    draw_sprite_stretched(_page.sprite, 0, _img_x, _img_y, _img_w, _img_h);
    draw_set_color(make_color_rgb(220, 176, 67));
    draw_rectangle(_img_x - 2, _img_y - 2, _img_x + _img_w + 2, _img_y + _img_h + 2, true);
}

var _text_x = _img_x + _img_w + max(20, _content_w * 0.03);
var _text_w = max(180, _panel_x2 - _inner - _text_x);
var _text_y = _panel_y1 + max(26, _panel_h * 0.065);

if (font_exists(fnt_main)) draw_set_font(fnt_main);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(fade_alpha);
draw_set_color(make_color_rgb(110, 205, 235));
draw_text_ext(_text_x, _text_y, string_upper(lc(_page.category_key)), 16, _text_w);

_text_y += max(28, _panel_h * 0.055);
if (font_exists(fnt_title)) draw_set_font(fnt_title);
draw_set_color(make_color_rgb(245, 202, 92));
var _title = lc(_page.title_key);
draw_text_ext(_text_x, _text_y, _title, 22, _text_w);
var _title_h = string_height_ext(_title, 22, _text_w);
_text_y += max(42, _title_h + 18);

if (font_exists(fnt_main)) draw_set_font(fnt_main);
draw_set_color(make_color_rgb(235, 240, 244));
var _body = lc(_page.body_key);
var _body_max_h = max(70, _usable_bottom - _text_y - 8);
var _body_sep = 22;
var _body_h = string_height_ext(_body, _body_sep, _text_w);
while (_body_h > _body_max_h && _body_sep > 15)
{
    _body_sep -= 1;
    _body_h = string_height_ext(_body, _body_sep, _text_w);
}
draw_text_ext(_text_x, _text_y, _body, _body_sep, _text_w);

// Footer/navigation.
var _footer = lc("cutscene_continue");
if (page_index + 1 >= array_length(pages)) _footer = lc("cutscene_close");
var _footer_y = _panel_y2 - _footer_h * 0.5;
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(make_color_rgb(130, 210, 235));
draw_text_ext(_panel_x1 + _panel_w * 0.5, _footer_y, _footer, 16, _panel_w * 0.72);

if (array_length(pages) > 1)
{
    draw_set_halign(fa_right);
    draw_set_color(make_color_rgb(175, 180, 190));
    draw_text(_panel_x2 - _inner, _footer_y, string(page_index + 1) + "/" + string(array_length(pages)));
}

// The regular UI/cursor instances are suspended while the cutscene is active,
// so draw the custom cursor here as the final GUI element.
yp_draw_cursor();

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
