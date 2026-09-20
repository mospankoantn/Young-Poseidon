/// @description Clear inactive/active/activation visuals for checkpoints.

var _cx = (bbox_left + bbox_right) * 0.5;
var _cy = bbox_top + 28;
var _pulse = 0.5 + 0.5 * sin(current_time / 170);

// Persistent glow behind the currently active checkpoint.
if (is_activated)
{
    gpu_set_blendmode(bm_add);
    draw_set_alpha(0.10 + 0.08 * _pulse);
    draw_set_color(make_color_rgb(80, 220, 255));
    draw_circle(_cx, _cy, 18 + 3 * _pulse, false);
    draw_set_alpha(0.20 + 0.10 * _pulse);
    draw_circle(_cx, _cy, 11 + 2 * _pulse, false);
    gpu_set_blendmode(bm_normal);
}

// Inactive checkpoints are deliberately muted; active ones are bright.
draw_set_alpha(1);
draw_set_color(c_white);
draw_sprite_ext(
    spr_checkpoint, 0, x, y,
    image_xscale, image_yscale, 0,
    is_activated ? c_white : make_color_rgb(105, 125, 135),
    is_activated ? 1 : 0.78
);

if (is_activated)
{
    // Stable blue core so the player can tell which checkpoint is active.
    gpu_set_blendmode(bm_add);
    draw_set_alpha(0.55 + 0.25 * _pulse);
    draw_set_color(make_color_rgb(70, 225, 255));
    draw_circle(_cx, _cy, 5 + _pulse * 2, true);
    gpu_set_blendmode(bm_normal);
}

// One-shot activation burst.
if (activation_fx_timer > 0)
{
    var _t = 1 - activation_fx_timer / activation_fx_length;
    var _radius = 8 + _t * 28;
    var _alpha = 1 - _t;

    gpu_set_blendmode(bm_add);
    draw_set_alpha(0.7 * _alpha);
    draw_set_color(make_color_rgb(255, 220, 95));
    draw_circle(_cx, _cy, _radius, false);

    draw_set_color(make_color_rgb(95, 235, 255));
    for (var _i = 0; _i < 8; _i++)
    {
        var _ang = _i * 45 + current_time / 12;
        var _px = _cx + lengthdir_x(_radius, _ang);
        var _py = _cy + lengthdir_y(_radius, _ang);
        draw_circle(_px, _py, 2, true);
    }

    gpu_set_blendmode(bm_normal);
}

draw_set_alpha(1);
draw_set_color(c_white);
