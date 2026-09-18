/// @description рух риби
/// obj_fish — Step Event

// Хвилеподібний рух по вертикалі
wave_offset += wave_speed;
y = base_y + sin(wave_offset) * wave_amp;

// Горизонтальний рух
x += swim_speed * move_dir;

// Розворот на межах
if (x <= left_bound || x >= right_bound)
{
    move_dir    *= -1;
    image_xscale = move_dir;

    // Невелика пауза перед розворотом — рибка "вагається"
    swim_speed = random_range(0.8, 2.2);
}

// Рідкісний випадковий розворот (рибка змінює рішення)
if (turn_timer <= 0 && irandom(300) == 0)
{
    move_dir    *= -1;
    image_xscale = move_dir;
    turn_timer   = 60;
}
if (turn_timer > 0) turn_timer--;