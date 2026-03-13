/// @description 
// obj_player Step Event

// ============================================================
// БЛОК 1: ЧИТАННЯ КЛАВІАТУРИ
// ============================================================
var _a            = keyboard_check(ord("A")) || keyboard_check(vk_left);
var _d            = keyboard_check(ord("D")) || keyboard_check(vk_right);
var _f_pressed    = keyboard_check_pressed(ord("F"));       // Кинути зброю
var _1_pressed    = keyboard_check_pressed(ord("1"));       // Повернути тризубець
var _space_pressed= keyboard_check_pressed(vk_space)
                    || keyboard_check_pressed(vk_up)
                    || keyboard_check_pressed(ord("W"));    // Стрибок
var _2_pressed    = keyboard_check_pressed(ord("2"));       // Зілля здоров'я
var _3_pressed    = keyboard_check_pressed(ord("3"));       // Зілля сили
var _4_pressed    = keyboard_check_pressed(ord("4"));       // Зілля швидкості
 
// ============================================================
// БЛОК 2: ЗАМОРОЗКА (від крику Тіні Аїда)
// ============================================================
// Якщо гравець заморожений — він не може рухатись
if (is_frozen)
{
    freeze_timer--;
    if (freeze_timer <= 0)
    {
        is_frozen    = false;
        freeze_timer = 0;
    }
    // Зупиняємо горизонтальний рух, але гравець падає нормально
    _a = false;
    _d = false;
}
 
// ============================================================
// БЛОК 3: ГОРИЗОНТАЛЬНИЙ РУХ
// ============================================================
var _move = _d - _a;  // -1 = вліво, 0 = стояти, 1 = вправо
 
// Поточна швидкість = базова * множник зброї + бонуси
var _weapon_spd   = weapon_spd_mult[current_weapon];
var _current_spd  = spd * _weapon_spd * 10 + (perm_spd_bonus + temp_spd_buff) * 10;
var _move_hspd    = _move * _current_spd;
 
// Напрямок погляду (оновлюємо лише під час руху)
if (_move > 0)
{
    l_right      = true;
    image_xscale = 1;
}
else if (_move < 0)
{
    l_right      = false;
    image_xscale = -1;
}
 
// ============================================================
// БЛОК 4: ГРАВІТАЦІЯ
// ============================================================
vspd += grv;
if (vspd > 20) vspd = 20;  // Максимальна швидкість падіння
 
// ============================================================
// БЛОК 5: ЗІТКНЕННЯ ТА РУХ
// ============================================================
 
// --- ГОРИЗОНТАЛЬ ---
// Рахуємо загальний горизонтальний зсув: рух + knockback
var _total_hspd = _move_hspd + hspd;
 
if (place_meeting(x + _total_hspd, y, obj_platform))
{
    while (!place_meeting(x + sign(_total_hspd), y, obj_platform))
        x += sign(_total_hspd);
    _total_hspd = 0;
    hspd        = 0;  // Knockback гасимо при ударі в стіну
}
x += _total_hspd;
 
// Загасання knockback (щоб відштовхування поступово зменшувалось)
hspd *= 0.75;
if (abs(hspd) < 0.5) hspd = 0;
 
// --- СТРИБОК (тільки коли стоїмо на землі) ---
var _on_ground = place_meeting(x, y + 1, obj_platform);
if (_on_ground && _space_pressed)
{
    vspd = -12;
    if (audio_exists(snd_jump)) audio_play_sound(snd_jump, 1, false);
}
 
// --- ВЕРТИКАЛЬ ---
if (place_meeting(x, y + vspd, obj_platform))
{
    while (!place_meeting(x, y + sign(vspd), obj_platform))
        y += sign(vspd);
    vspd = 0;
}
y += vspd;
 
// ============================================================
// БЛОК 6: МЕХАНІКА ТРИЗУБЦЯ (клавіші F та 1)
// Працює лише якщо обрана зброя — Тризубець або Спис (індекси 0 і 1)
// ============================================================
var _weapon_can_throw = (current_weapon == 0 || current_weapon == 1);
 
if (_weapon_can_throw)
{
    // Знаходимо тризубець якщо ще не маємо посилання
    if (!instance_exists(trident_instance))
        trident_instance = instance_find(obj_trident, 0);
 
    // --- F: Кинути тризубець ---
    if (_f_pressed && instance_exists(trident_instance))
    {
        var _t = trident_instance;
 
        if (_t.stuck)
        {
            // Якщо тризубець застряг — F знімає його зі стіни і кидає знову
            _t.stuck  = false;
            var _n = instance_number(obj_trident_platform);
            for (var _i = _n - 1; _i >= 0; _i--)
            {
                var _plat = instance_find(obj_trident_platform, _i);
                if (instance_exists(_plat)) instance_destroy(_plat);
            }
        }
 
        if (!_t.thrown && !_t.stuck)
        {
            _t.thrown        = true;
            _t.timer         = 0;
            _t.x             = x + (image_xscale * 24);
            _t.y             = y - 8;
            _t.image_xscale  = image_xscale;
        }
    }
 
    // --- 1: Повернути тризубець звідусіль ---
    if (_1_pressed && instance_exists(trident_instance))
    {
        var _t = trident_instance;
        if (_t.stuck)
        {
            // Знищуємо платформи
            var _n = instance_number(obj_trident_platform);
            for (var _i = _n - 1; _i >= 0; _i--)
            {
                var _plat = instance_find(obj_trident_platform, _i);
                if (instance_exists(_plat)) instance_destroy(_plat);
            }
            _t.stuck       = false;
            _t.thrown      = false;
            _t.image_angle = 0;
        }
        else if (_t.thrown)
        {
            // Повертаємо навіть якщо ще летить
            _t.thrown      = false;
            _t.timer       = 0;
            _t.image_angle = 0;
        }
    }
}
 
 // ════ ПЕРЕКЛЮЧЕННЯ ЗБРОЇ ════
 
// --- Цифрові клавіші 1-6: пряме переключення ---
// Клавіша вже зайнята на "1" для тризубця!
// Тому використовуємо клавіші 3-8 (зсув +2) або Q/E/колесо миші.
// РЕКОМЕНДОВАНИЙ ВАРІАНТ: Q — попередня зброя, E — наступна
 
var _switch_next = keyboard_check_pressed(ord("Q"));
var _switch_prev = keyboard_check_pressed(ord("Z"));
var _wheel_up    = mouse_wheel_up();
var _wheel_down  = mouse_wheel_down();
 
// Переключення вперед (Q або колесо вгору)
if (_switch_next || _wheel_up)
{
    _switch_weapon(1);   // +1 до поточного індексу
}
 
// Переключення назад (Z або колесо вниз)
if (_switch_prev || _wheel_down)
{
    _switch_weapon(-1);  // -1 до поточного індексу
}
 
// --- Швидкий вибір Tab: відкрити колесо вибору ---
if (keyboard_check_pressed(vk_tab))
{
    if (!instance_exists(obj_weapon_selector))
        instance_create_layer(0, 0, "Instances", obj_weapon_selector);
}
 
// ============================================================
// БЛОК 7: МЕЧ — ВИПАД (клавіша F при current_weapon == 5)
// ============================================================
if (current_weapon == 5 && _f_pressed)
{
    // Випад: різкий ривок вперед
    var _dash_dir = l_right ? 0 : 180;
    hspd = lengthdir_x(18, _dash_dir);
    // Шкода ворогу попереду
    var _hit = instance_place(x + image_xscale * 40, y, obj_enemy);
    if (instance_exists(_hit))
    {
        with (_hit)
        {
            hp -= (obj_player.weapon_atk[obj_player.current_weapon]
                   + obj_player.temp_atk_buff);
        }
    }
}
 
// ============================================================
// БЛОК 8: СМЕРТЬ
// ============================================================
if (hp <= 0)
{
    hp = max_hp;  // Відновлюємо здоров'я
 
    if (variable_global_exists("checkpoint_room")
        && global.checkpoint_room == room)
    {
        // Відроджуємось на чекпоінті в тій самій кімнаті
        x    = global.checkpoint_x;
        y    = global.checkpoint_y;
        vspd = 0;
        hspd = 0;
    }
    else if (variable_global_exists("checkpoint_room"))
    {
        // Переходимо до кімнати з чекпоінтом
        room_goto(global.checkpoint_room);
    }
    else
    {
        // Немає чекпоінту — перезапуск гри
        game_restart();
    }
}
 
// ============================================================
// БЛОК 9: ТАЙМЕР ТИМЧАСОВИХ БАФІВ
// ============================================================
if (buff_duration > 0)
{
    buff_duration--;
    if (buff_duration <= 0)
    {
        temp_spd_buff = 0;
        temp_atk_buff = 0;
    }
}
 
// ============================================================
// БЛОК 10: ВИКОРИСТАННЯ ЗІЛЛЯ
// ============================================================
 
// [2] Зілля здоров'я — відновлює 2 HP
if (_2_pressed && potion_heal_count > 0 && hp < max_hp)
{
    hp = min(hp + 2, max_hp);
    potion_heal_count--;
    // audio_play_sound(snd_potion_heal, 1, false);
}
 
// [3] Зілля сили — +2 атака на 10 секунд
if (_3_pressed && potion_strength_count > 0 && buff_duration <= 0)
{
    potion_strength_count--;
    temp_atk_buff = 2;
    buff_duration = room_speed * 10;
    // audio_play_sound(snd_potion_strength, 1, false);
}
 
// [4] Зілля швидкості — +1 швидкість на 10 секунд
if (_4_pressed && potion_speed_count > 0 && buff_duration <= 0)
{
    potion_speed_count--;
    temp_spd_buff = 1;
    buff_duration = room_speed * 10;
    // audio_play_sound(snd_potion_speed, 1, false);
}
