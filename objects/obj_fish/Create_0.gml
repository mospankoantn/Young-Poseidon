/// @description Створення риби
/// obj_fish — Create Event

// ── Випадковий спрайт рибки ──
var _fish_sprites = [
    spr_fish_1,
    spr_fish_2
];
sprite_index = _fish_sprites[irandom(array_length(_fish_sprites) - 1)];
image_speed  = 0.15;

// ── Напрямок плавання ──
move_dir   = choose(1, -1);      // 1=вправо, -1=вліво
swim_speed = random_range(0.4, 0.8);
image_xscale = move_dir;

// ── Зона плавання (відносно стартової позиції) ──
left_bound  = x - random_range(200, 400);
right_bound = x + random_range(200, 400);

// ── Хвилеподібний рух (синусоїда по Y) ──
wave_offset = random(pi * 2);   // Рандомна фаза щоб рибки не рухались синхронно
wave_amp    = random_range(4, 14);
wave_speed  = random_range(0.02, 0.06);
base_y      = y;

// ── Зміна напрямку ──
turn_timer  = 0;