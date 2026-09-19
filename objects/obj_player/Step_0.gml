/// @description
/// @description obj_player — Step Event

if (hp <= 0 && !is_dead) _begin_player_death();
if (is_dead)
{
    if (death_finished) _respawn_player();
    exit;
}

// ════════════════════════════════════════
// АНІМАЦІЙНІ ТАЙМЕРИ
// ════════════════════════════════════════
if (anim_action_timer > 0) anim_action_timer--;
if(instance_exists(riding_cart) && riding_cart.has_player) {
    riding_cart._sync_rider();
    exit;
}
if(!instance_exists(riding_cart)) riding_cart=noone;
image_xscale = l_right ? 1 : -1;

// ════════════════════════════════════════
// БЛОК 1: ЧИТАННЯ КЛАВІШ
// ════════════════════════════════════════
var _left  = yp_input("A",false) || keyboard_check(vk_left);
var _right = yp_input("D",false) || keyboard_check(vk_right);
var _jump  = yp_input("W",true) || keyboard_check_pressed(vk_up);
var _drop  = yp_input("S",true) || keyboard_check_pressed(vk_down);

var _e_pressed = yp_input("E",true);   // Кидок зброї
// Interacting with a nearby mechanism should not also throw a held weapon.
if(instance_exists(prop_nearest_button())) _e_pressed=false;
if(instance_exists(obj_mine_cart)) {
    var _cart=instance_nearest(x,y,obj_mine_cart);
    if(distance_to_object(_cart)<=_cart.interact_range) _e_pressed=false;
}
var _f_pressed = yp_input("F",true);   // Взаємодія з предметом
var _q_pressed = yp_input("Q",true);   // Закрити діалог

// Зілля
var _z_pressed = yp_input("Z",true);   // Зілля здоров'я
var _x_pressed = yp_input("X",true);   // Зілля Геракла
var _c_pressed = yp_input("C",true);   // Зілля Гермеса

// Колесо миші — переключення зброї
var _wheel_up   = mouse_wheel_up();
var _wheel_down = mouse_wheel_down();

// Клавіші 1-6 — пряме переключення зброї
for (var _ki = 0; _ki < 6; _ki++)
{
    if (keyboard_check_pressed(ord(string(_ki + 1))))
    {
        if (weapon_unlocked[_ki])
            current_weapon = _ki;
    }
}

// Колесо миші
if (_wheel_up)   _switch_weapon(1);
if (_wheel_down) _switch_weapon(-1);

if (current_weapon >= array_length(weapon_unlocked))
    current_weapon = -1;

// ════════════════════════════════════════
// БЛОК 2: ЗАМОРОЗКА (Тінь Аїда)
// ════════════════════════════════════════
if (is_frozen)
{
    freeze_timer--;
    if (freeze_timer <= 0) { is_frozen = false; }
    _left = false; _right = false;
}

// ════════════════════════════════════════
// БЛОК 3: РУХ
// ════════════════════════════════════════
var _move = _right - _left;

var _weapon_spd  = (current_weapon >= 0) ? weapon_spd_mult[current_weapon] : 1.0;
var _current_spd = spd * _weapon_spd * 10 + (perm_spd_bonus + temp_spd_buff) * 10;
var _move_hspd   = _move * _current_spd;

if (_move > 0) { l_right = true;  image_xscale =  1; }
if (_move < 0) { l_right = false; image_xscale = -1; }

// ════════════════════════════════════════
// БЛОК 4: ГРАВІТАЦІЯ
// ════════════════════════════════════════
vspd += grv;
if (vspd > 20) vspd = 20;

// ════════════════════════════════════════
// БЛОК 5: ЗІТКНЕННЯ З ПЛАТФОРМАМИ
// ════════════════════════════════════════
var _on_ground = place_meeting(x, y + 1, obj_platform);

// --- S: Проскочити крізь тонку платформу ---
// (лише якщо платформа є obj_thin_platform — нащадок obj_platform)
if (_drop && place_meeting(x, y + 1, obj_thin_platform) && vspd >= 0)
{
    drop_timer = 20;   // ігноруємо тонку 20 кадрів (~0.3 сек)
}
if (drop_timer > 0) drop_timer--;


// Горизонталь
var _total_hspd = _move_hspd + hspd;
if (place_meeting(x + _total_hspd, y, obj_platform))
{
    while (!place_meeting(x + sign(_total_hspd), y, obj_platform))
        x += sign(_total_hspd);
    _total_hspd = 0;
    hspd        = 0;
}
x += _total_hspd;

hspd *= 0.75;
if (abs(hspd) < 0.5) hspd = 0;

// Стрибок
if (_on_ground && _jump)
{
    vspd = -12;
    if (audio_exists(snd_jump)) audio_play_sound(snd_jump, 1, false);
}

// Вертикаль
if (place_meeting(x, y + vspd, obj_platform))
{
    var _only_thin = place_meeting(x, y + vspd, obj_thin_platform);

    // Ігноруємо тонку платформу якщо:
    // 1. Летимо ВГОРУ (стрибок)
    // 2. Провалюємося (drop_timer > 0)
    // 3. Вже знаходимося всередині неї (застрягли)
    var _ignore_thin = (vspd < 0)
                       || (drop_timer > 0)
                       || place_meeting(x, y, obj_thin_platform);

    // Якщо на шляху ТІЛЬКИ тонка і ми її ігноруємо — проходимо крізь
    if (_only_thin && _ignore_thin)
    {
        // Нічого не робимо
    }
    else
    {
        while (!place_meeting(x, y + sign(vspd), obj_platform)
               || (_ignore_thin && place_meeting(x, y + sign(vspd), obj_thin_platform)))
        {
            y += sign(vspd);
        }
        vspd = 0;
    }
}
y += vspd;

// ════════════════════════════════════════
// БЛОК 6: ЗБРОЯ — E (КИДОК) і F (ПОВЕРНЕННЯ/ВЗАЄМОДія)
// ════════════════════════════════════════
var _can_throw = (current_weapon == 0 || current_weapon == 1);

if (_can_throw && instance_exists(trident_instance))
{
    var _t = trident_instance;

    // E — кинути зброю
    if (_e_pressed)
    {
        if (_t.stuck)
        {
            // Знімаємо зі стіни і кидаємо знову
            _t.stuck = false;
            var _n   = instance_number(obj_trident_platform);
            for (var _i = _n - 1; _i >= 0; _i--)
            {
                var _pl = instance_find(obj_trident_platform, _i);
                if (instance_exists(_pl)) instance_destroy(_pl);
            }
        }
        if (!_t.thrown && !_t.stuck)
        {
			audio_play_sound(snd_swing, 1, false);
            _t.thrown       = true;
            _t.timer        = 0;
            _t.x            = x + image_xscale * 24;
            // The player origin is at the feet; launch from chest/hand height.
            _t.y            = bbox_top + (bbox_bottom - bbox_top) * 0.5;
            _t.image_angle  = 0;
            _t.invisible_time = false;
            _t.image_xscale = image_xscale;
            _t.visual_weapon = current_weapon;
            _t.damage        = weapon_atk[current_weapon];
            _play_weapon_action("cast");
        }
    }

    // Повернення використовує перепризначувану дію F. Цифри 1-6 тільки вибирають слот.
    if (_f_pressed)
    {
        if (_t.stuck || _t.thrown)
        {
            var _n = instance_number(obj_trident_platform);
            for (var _i = _n - 1; _i >= 0; _i--)
            {
                var _pl = instance_find(obj_trident_platform, _i);
                if (instance_exists(_pl)) instance_destroy(_pl);
            }
            _t.stuck       = false;
            _t.thrown      = false;
            _t.image_angle = 0;
            _play_weapon_action("recall");
        }
    }
}

// Кайло / коса / весло / меч — звичайна ближня атака.
// Спеціальні взаємодії інструментів із брилами/хащами/плотом залишаються в їхніх об'єктах.
if (_e_pressed && current_weapon >= 2 && current_weapon <= 5)
{
    _play_weapon_action("attack");

    // Меч зберігає свій швидкий випад уперед.
    if (current_weapon == 5)
        hspd = image_xscale * 18;

    _damage_weapon_melee(current_weapon);
}

// ════════════════════════════════════════
// БЛОК 7: СМЕРТЬ
// ════════════════════════════════════════
// Lethal collision damage is handled in End Step, before animation selection.

// ════════════════════════════════════════
// БЛОК 8: ТИМЧАСОВІ БАФИ
// ════════════════════════════════════════
if (buff_duration > 0)
{
    buff_duration--;
    if (buff_duration <= 0) { temp_spd_buff = 0; temp_atk_buff = 0; }
}

// ════════════════════════════════════════
// БЛОК 9: ЗІЛЛЯ (Z / X / C)
// ════════════════════════════════════════

// Z — Зілля здоров'я: відновлює 5 HP (з дизайн-документу)
if (_z_pressed && potion_heal_count > 0 && hp < max_hp)
{
    hp = min(hp + 5, max_hp);
    potion_heal_count--;
    // audio_play_sound(snd_potion_heal, 1, false);
}

// X — Зілля Геракла: +5 ATK на 60 секунд (з дизайн-документу)
if (_x_pressed && potion_strength_count > 0 && buff_duration <= 0)
{
    potion_strength_count--;
    temp_atk_buff = 5;
    buff_duration = room_speed * 60;   // 60 секунд
    // audio_play_sound(snd_potion_strength, 1, false);
}

// C — Зілля Гермеса: +1 SPD на 60 секунд (з дизайн-документу)
if (_c_pressed && potion_speed_count > 0 && buff_duration <= 0)
{
    potion_speed_count--;
    temp_spd_buff = 1;
    buff_duration = room_speed * 60;   // 60 секунд
    // audio_play_sound(snd_potion_speed, 1, false);
}

// ════════════════════════════════════════
// ВИХІД ЗА МЕЖІ КІМНАТИ
// ════════════════════════════════════════
var _margin = 32;   // Скільки пікселів за межею до спрацювання

// Низ, ліво, право — втрата HP + телепорт
if (y > room_height + _margin
 || x < -_margin
 || x > room_width + _margin)
{
    // Втрата 1 HP
    hp--;
    if (hp <= 0)
    {
        _begin_player_death();
        exit;
    }
    // audio_play_sound(snd_fall, 1, false);

    // Телепорт на безпечну позицію чекпоінта
    if (variable_global_exists("checkpoint_room")
        && global.checkpoint_room == room)
    {
        if (!player_place_safely(id, global.checkpoint_x, global.checkpoint_y))
            player_place_safely(id, xstart, ystart);

        global.checkpoint_x = x;
        global.checkpoint_y = y;
    }
    else if (variable_global_exists("checkpoint_room"))
    {
        global.checkpoint_respawn_pending = true;
        global.spawn_from_tag = "";
        global.spawn_x_manual = -1;
        global.spawn_y_manual = -1;
        global.came_from_room = -1;
        room_goto(global.checkpoint_room);
    }
    else
    {
        // Немає чекпоінту — повертаємо на стартову безпечну позицію
        if (!player_place_safely(id, xstart, ystart))
        {
            x = xstart;
            y = ystart;
            hspd = 0;
            vspd = 0;
        }
    }

    // Короткочасна невразливість після падіння
    is_damage   = true;
    alarm[0]    = room_speed;
    _reset_player_animation();
}

// Верх — НЕ обмежуємо (гравець може стрибати вище кімнати)
