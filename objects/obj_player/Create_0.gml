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

// ════ АНІМАЦІЇ ════
// Стара маска залишається активною: нові кадри не змінюють колізії гравця.
mask_index = spr_player;
sprite_index = spr_player_idle;
image_index = 0;
image_speed = 1;

anim_action_sprite = -1;
anim_action_timer = 0;
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
    if (is_dead) return;
    if (anim_action_sprite == spr_player_hurt && anim_action_timer > 0
        && _sprite != spr_player_hurt) return;

    anim_action_sprite = _sprite;
    // Gameplay clips store their playback speed in frames per second.
    anim_action_timer = ceil(sprite_get_number(_sprite) * room_speed / sprite_get_speed(_sprite));
    _set_player_animation(_sprite, 1, true);
};

_reset_player_animation = function()
{
    is_dead = false;
    death_finished = false;
    anim_action_sprite = -1;
    anim_action_timer = 0;
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
    // Preserve the existing checkpoint and no-checkpoint branches.
    hp = max_hp;
    if (variable_global_exists("checkpoint_room") && global.checkpoint_room == room)
    {
        x = global.checkpoint_x;
        y = global.checkpoint_y;
        vspd = 0; hspd = 0;
    }
    else if (variable_global_exists("checkpoint_room"))
        room_goto(global.checkpoint_room);
    else
        game_restart();
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
 
// Розблокована зброя (false = ще не отримана)
weapon_unlocked = [false, false, false, false, false, false];
// На початку гравець БЕЗ ЗБРОЇ — отримає Тризубець від Тритона
 
current_weapon = -1;  // -1 = немає зброї
 
// ════ ТРИЗУБЕЦЬ / СПИС ════
trident_instance = noone;
 
// ════ КЛЮЧ ОЛІМПУ ════
has_olympus_key = false;
 
// ════ ФУНКЦІЇ ════
_unlock_weapon = function(_index)
{
    if (_index < 0 || _index >= array_length(weapon_unlocked)) exit;

    weapon_unlocked[_index] = true;
    current_weapon          = _index;
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

apply_pending_load_to_player();
_reset_player_animation();
