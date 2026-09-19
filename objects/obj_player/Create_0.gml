/// @description
/// obj_player — Create Event

// Persistent-гравець переноситься між кімнатами. Якщо кімната також має
// розміщений obj_player, новий дубль одразу прибираємо.
if (instance_number(obj_player) > 1)
{
    instance_destroy();
    exit;
}

// ════ ЗДОРОВ'Я ════
hp     = 5;
max_hp = 5;

// ════ ЗІЛЛЯ (клавіші Z / X / C) ════
potion_heal_count     = 0;   // Z — зілля здоров'я (+5 HP)
potion_strength_count = 0;   // X — зілля Геракла  (+5 ATK на 60с)
potion_speed_count    = 0;   // C — зілля Гермеса  (+1 SPD на 60с)

// ════ ХАРАКТЕРИСТИКИ ════
spd            = 1;       // Базова швидкість (sp=1 з документу)
perm_spd_bonus = 0;       // +1 за кожен сандаль Гермеса (макс 2)
temp_spd_buff  = 0;       // +1 від зілля Гермеса
temp_atk_buff  = 0;       // +5 від зілля Геракла
buff_duration  = 0;       // Кадри до кінця тимчасового бафу

// ════ ФІЗИКА ════
hspd = 0;    // Горизонтальна швидкість (knockback)
vspd = 0;    // Вертикальна швидкість
grv  = 0.8;  // Гравітація
drop_timer = 0;   // коли > 0 — падаємо крізь тонку платформу

// ════ СТАН ════
l_right      = true;
is_damage    = false;
is_frozen    = false;   // Заморозка від Тіні Аїда
freeze_timer = 0;
riding_cart = noone;

// ════ АНІМАЦІЇ ════
// Стара маска залишається активною: нові кадри не змінюють колізії гравця.
mask_index = spr_player;
sprite_index = spr_player_idle;
image_index = 0;
image_speed = 1;

anim_action_sprite = -1;
anim_action_timer = 0;
anim_action_weapon = -1;
anim_was_on_ground = false;
anim_was_damage = false;
anim_last_hp = hp;
anim_last_x = x;
is_dead = false;
death_finished = false;

_set_player_animation = function(_sprite, _speed, _restart = false)
{
    if (sprite_index != _sprite || _restart)
    {
        sprite_index = _sprite;
        image_index = 0;
    }

    image_speed = _speed;
};

_play_player_action = function(_sprite)
{
    if (is_dead) return false;
    if (anim_action_sprite == spr_player_hurt && anim_action_timer > 0
        && _sprite != spr_player_hurt) return false;

    anim_action_sprite = _sprite;
    anim_action_weapon = -1;
    // Gameplay clips store their playback speed in frames per second.
    anim_action_timer = ceil(sprite_get_number(_sprite) * room_speed / sprite_get_speed(_sprite));
    _set_player_animation(_sprite, 1, true);
    return true;
};

_reset_player_animation = function()
{
    is_dead = false;
    death_finished = false;
    anim_action_sprite = -1;
    anim_action_timer = 0;
    anim_action_weapon = -1;
    anim_was_on_ground = place_meeting(x, y + 1, obj_platform);
    anim_was_damage = is_damage;
    anim_last_hp = hp;
    anim_last_x = x;
    image_xscale = l_right ? 1 : -1;
    _set_player_animation(spr_player_idle, 1, true);
};

_begin_player_death = function()
{
    if (is_dead) return;
    is_dead = true;
    death_finished = false;
    anim_action_timer = 0;
    anim_action_sprite = -1;
    hspd = 0;
    vspd = 0;
    is_damage = true;
    image_alpha = 1;
    _set_player_animation(spr_player_death, 1, true);
};

_respawn_player = function()
{
    hp = max_hp;

    if (variable_global_exists("checkpoint_room") && global.checkpoint_room == room)
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
        game_restart();
    }

    is_damage = alarm[0] > 0;
    _reset_player_animation();
};

// ════ ЗБРОЯ ════
// Індекси: 0=Тризубець 1=Спис 2=Кайло 3=Коса 4=Весло 5=Меч
weapon_names = [
    lc("weapon_trident"),
    lc("weapon_spear"),
    lc("weapon_pickaxe"),
    lc("weapon_scythe"),
    lc("weapon_oar"),
    lc("weapon_sword")
];
weapon_sprites  = [spr_weapon_trident, spr_weapon_spear,
                   spr_weapon_pickaxe, spr_weapon_scythe,
                   spr_weapon_oar,     spr_weapon_sword];

// ATK і множник SPD — точно з дизайн-документу
weapon_atk      = [1, 2, 5, 3, 4, 10];
weapon_spd_mult = [1.0, 2.0, 0.25, 1.0, 0.5, 2.0];

// Радіус звичайної ближньої атаки. Тризубець/спис (0/1) наносять шкоду снарядом.
weapon_melee_range = [0, 0, 48, 58, 62, 54];

_damage_weapon_melee = function(_weapon_index)
{
    if (_weapon_index < 2 || _weapon_index > 5) return noone;

    var _range  = weapon_melee_range[_weapon_index];
    var _near_x = x + image_xscale * 8;
    var _far_x  = x + image_xscale * _range;
    var _x1 = min(_near_x, _far_x);
    var _x2 = max(_near_x, _far_x);
    var _y1 = bbox_top + 4;
    var _y2 = bbox_bottom - 4;

    var _target = collision_rectangle(_x1, _y1, _x2, _y2, obj_enemy, false, true);
    if (instance_exists(_target) && variable_instance_exists(_target, "hp"))
    {
        _target.hp -= weapon_atk[_weapon_index] + temp_atk_buff;
        return _target;
    }

    return noone;
};

// Розблокована зброя (false = ще не отримана)
weapon_unlocked = [false, false, false, false, false, false];
// На початку гравець БЕЗ ЗБРОЇ — отримає Тризубець від Тритона

current_weapon = -1;  // -1 = немає зброї

// ════ ТРИЗУБЕЦЬ / СПИС ════
trident_instance = noone;

// ════ КЛЮЧ ОЛІМПУ ════
has_olympus_key = false;

// Sheets provide grounded locomotion and actions; airborne/hurt/death keep their original clips.
weapon_animations = [
    { idle: spr_player_trident_idle, run: spr_player_trident_run, pickup: spr_player_trident_pickup, attack: spr_player_trident_attack, cast: spr_player_trident_cast, recall: spr_player_trident_recall, special: spr_player_trident_attack },
    { idle: spr_player_spear_idle, run: spr_player_spear_run, pickup: spr_player_spear_pickup, attack: spr_player_spear_attack, cast: spr_player_spear_cast, recall: spr_player_spear_recall, special: spr_player_spear_attack },
    { idle: spr_player_pickaxe_idle, run: spr_player_pickaxe_run, pickup: spr_player_pickaxe_pickup, attack: spr_player_pickaxe_attack, special: spr_player_pickaxe_special },
    { idle: spr_player_scythe_idle, run: spr_player_scythe_run, pickup: spr_player_scythe_pickup, attack: spr_player_scythe_attack, special: spr_player_scythe_special },
    { idle: spr_player_oar_idle, run: spr_player_oar_run, pickup: spr_player_oar_pickup, attack: spr_player_oar_attack, special: spr_player_oar_special },
    { idle: spr_player_sword_idle, run: spr_player_sword_run, pickup: spr_player_sword_pickup, attack: spr_player_sword_attack, special: spr_player_sword_special }
];

_weapon_in_hand = function()
{
    if (current_weapon < 0 || current_weapon >= array_length(weapon_animations)) return false;
    if (current_weapon <= 1 && instance_exists(trident_instance))
    {
        var _t = trident_instance;
        if (_t.thrown || _t.stuck || point_distance(x, y, _t.x, _t.y) >= 20) return false;
    }
    return true;
};

_weapon_locomotion = function(_running)
{
    if (!_weapon_in_hand()) return _running ? spr_player_run : spr_player_idle;
    return _running ? weapon_animations[current_weapon].run : weapon_animations[current_weapon].idle;
};

_play_weapon_action = function(_kind)
{
    if (current_weapon < 0 || current_weapon >= array_length(weapon_animations)) return;
    var _clips = weapon_animations[current_weapon];
    if (!variable_struct_exists(_clips, _kind)) return;
    if (_play_player_action(variable_struct_get(_clips, _kind))) anim_action_weapon = current_weapon;
};

// ════ ФУНКЦІЇ ════
_unlock_weapon = function(_index)
{
    if (_index < 0 || _index >= array_length(weapon_unlocked)) exit;

    weapon_unlocked[_index] = true;
    if (!variable_global_exists("weapon_unlocked")
        || !is_array(global.weapon_unlocked)
        || array_length(global.weapon_unlocked) != array_length(weapon_unlocked))
    {
        global.weapon_unlocked = array_create(array_length(weapon_unlocked), false);
    }
    global.weapon_unlocked[_index] = true;
    current_weapon          = _index;
    _play_weapon_action("pickup");
};

_switch_weapon = function(_delta)
{
    if (current_weapon == -1) exit;
    var _n = array_length(weapon_unlocked);
    var _next = current_weapon;
    repeat (_n)
    {
        _next = (_next + _delta + _n) mod _n;
        if (weapon_unlocked[_next]) { current_weapon = _next; break; }
    }
};

_reset_player_animation();
