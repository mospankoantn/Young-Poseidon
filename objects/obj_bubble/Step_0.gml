/// @description Поведінка бульбашки
/// obj_bubble — Step Event

switch (state)
{
    // ── 0: ПІДІЙМАЄТЬСЯ ──
    case 0:
        // Вертикальний підйом
        y -= rise_speed;

        // Горизонтальний дрейф (синусоїда)
        drift_offset += 0.04;
        x = spawn_x + sin(drift_offset) * 12 * image_xscale;

        // Плавне зникнення при наближенні до точки лопання
        if (y < fade_start_y)
        {
            var _fade_progress = (fade_start_y - y) / 40;
            image_alpha = max(0, image_alpha - _fade_progress * 0.03);
        }

        // Лопається коли майже зникла або вийшла за межі
        if (image_alpha <= 0.05 || y < -sprite_height)
        {
            state     = 1;
            pop_timer = 0;
            image_alpha = 0.7;
            // audio_play_sound(snd_bubble_pop, 1, false);
        }
    break;

    // ── 1: ЛОПАЄТЬСЯ ──
    case 1:
        pop_timer++;
        image_xscale *= 1.15;   // Розширюється
        image_yscale *= 1.15;
        image_alpha  -= 0.15;   // Швидко зникає

        if (pop_timer >= pop_timer_max)
        {
            // Відроджуємось знизу
            x            = spawn_x + random_range(-20, 20);
            y            = spawn_y + random_range(0, 30);
            var _scale   = random_range(0.3, 1.2);
            image_xscale = _scale;
            image_yscale = _scale;
            image_alpha  = random_range(0.3, 0.8);
            rise_speed   = random_range(0.4, 1.5);
            drift_speed  = random_range(-0.3, 0.3);
            drift_offset = random(pi * 2);
            fade_start_y = y - random_range(60, 150);
            state        = 0;
        }
    break;
}