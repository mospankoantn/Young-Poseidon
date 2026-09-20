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
grounded = false;  // єдине джерело істини для стану опори між Step/End Step

// ════ КОЛІЗІЇ ПЛАТФОРМ ════
// obj_thin_platform успадковується від obj_platform, тому звичайний
// place_meeting(..., obj_platform) бачить і тверді, і односторонні платформи.
// Для гравця розділяємо ці типи явно: тонкі не блокують рух збоку/знизу,
// а тверді завжди залишаються повноцінною колізією.
_is_thin_platform_instance = function(_inst)
{
    if (!instance_exists(_inst)) return false;

    var _obj = _inst.object_index;
    return (_obj == obj_thin_platform)
        || object_is_ancestor(_obj, obj_thin_platform);
};

_meets_solid_platform = function(_test_x, _test_y)
{
    // Швидкий шлях: немає жодної платформи.
    if (!place_meeting(_test_x, _test_y, obj_platform)) return false;

    // Якщо немає тонкої платформи, зіткнення точно тверде.
    if (!place_meeting(_test_x, _test_y, obj_thin_platform)) return true;

    // На стиках тонкої і твердої платформи треба перевірити всі колізії,
    // інакше thin-платформа може приховати solid-платформу.
    var _hits = ds_list_create();
    var _count = instance_place_list(_test_x, _test_y, obj_platform, _hits, false);
    var _solid_hit = false;

    for (var _i = 0; _i < _count; _i++)
    {
        var _hit = _hits[| _i];
        if (instance_exists(_hit) && !_is_thin_platform_instance(_hit))
        {
            _solid_hit = true;
            break;
        }
    }

    ds_list_destroy(_hits);
    return _solid_hit;
};

// Повертає Y, на якому ноги героя рівно стоять на найближчій поверхні
// потрібного типу, якщо вона знаходиться в межах невеликого ground-probe.
// Це прибирає субпіксельне "підстрибування" після гравітації: герой не
// повинен щокадру провалюватися на 0.8 px, а потім ловитися колізією.
_find_platform_support_y = function(_want_thin, _max_gap = 2.5)
{
    var _feet  = bbox_bottom;
    var _left  = bbox_left;
    var _right = bbox_right;
    var _found = false;
    var _best_delta = 1000000;

    // Пошук через obj_platform охоплює також його дочірні об'єкти;
    // thin-нащадків відділяємо явно.
    var _count = instance_number(obj_platform);
    for (var _i = 0; _i < _count; _i++)
    {
        var _hit = instance_find(obj_platform, _i);
        if (!instance_exists(_hit)) continue;

        var _is_thin = _is_thin_platform_instance(_hit);
        if (_is_thin != _want_thin) continue;

        // Для опори потрібне реальне горизонтальне перекриття стоп із платформою.
        if (_right < _hit.bbox_left || _left > _hit.bbox_right) continue;

        // У spr_player нижній піксель маски лежить на 1 px вище поверхні,
        // коли origin героя стоїть рівно на верхній грані платформи.
        var _target_feet = _hit.bbox_top - 1;
        var _delta = _target_feet - _feet;

        // Дозволяємо невеликий запас як вниз, так і вгору. Від'ємний допуск
        // ремонтує дрібне субпіксельне занурення, але не витягує героя зі стіни.
        if (_delta < -1.25 || _delta > _max_gap) continue;

        if (!_found || abs(_delta) < abs(_best_delta))
        {
            _best_delta = _delta;
            _found = true;
        }
    }

    return _found ? (y + _best_delta) : undefined;
};

// Якщо герой уже опинився трохи ВСЕРЕДИНІ solid-платформи зверху
// (наприклад після respawn/load/checkpoint), звичайний ground-probe не бачить
// опору: персонаж має vspd=0, але назавжди лишається "в повітрі".
// Ця функція знаходить верхню грань solid під нижньою частиною маски й
// повертає Y, який акуратно підніме героя НА поверхню. Бічні стіни не
// виправляємо: верх платформи має проходити тільки через нижні _max_penetration
// пікселів маски героя, а результат обов'язково перевіряється на відсутність
// solid-overlap.
_recover_solid_overlap_y = function(_max_penetration = 24)
{
    var _left = bbox_left;
    var _right = bbox_right;
    var _top_player = bbox_top;
    var _bottom = bbox_bottom;

    var _found = false;
    var _best_y = 0;
    var _best_penetration = 1000000;
    var _count = instance_number(obj_platform);

    for (var _i = 0; _i < _count; _i++)
    {
        var _hit = instance_find(obj_platform, _i);
        if (!instance_exists(_hit)) continue;
        if (_is_thin_platform_instance(_hit)) continue;

        if (_right < _hit.bbox_left || _left > _hit.bbox_right) continue;

        var _surface = _hit.bbox_top;
        // Платформа повинна перетинати саме нижню частину героя.
        if (_surface <= _top_player || _surface > _bottom) continue;

        var _penetration = _bottom - (_surface - 1);
        if (_penetration <= 0 || _penetration > _max_penetration) continue;

        var _candidate_y = y - _penetration;
        if (_meets_solid_platform(x, _candidate_y)) continue;

        if (!_found || _penetration < _best_penetration)
        {
            _best_penetration = _penetration;
            _best_y = _candidate_y;
            _found = true;
        }
    }

    return _found ? _best_y : undefined;
};

// true лише коли ноги героя реально спираються на верх solid-платформи.
_is_standing_on_solid_platform = function()
{
    return !is_undefined(_find_platform_support_y(false));
};

// true лише коли ноги героя реально спираються на верх thin-платформи.
_is_standing_on_thin_platform = function()
{
    return !is_undefined(_find_platform_support_y(true));
};

// Повертає Y точного приземлення на верх solid-платформи при русі вниз.
// На відміну від простого _meets_solid_platform(), ця функція ще й точно
// притискає стопи до верхньої грані. Це критично після drop-through: герой
// не залишається на частку пікселя над землею з vspd=0 і false ground-state.
_solid_landing_y = function(_next_y)
{
    if (_next_y <= y) return undefined;

    var _current_bottom = bbox_bottom;
    var _next_bottom = _current_bottom + (_next_y - y);
    var _left  = bbox_left;
    var _right = bbox_right;

    var _found = false;
    var _best_y = 0;
    var _count = instance_number(obj_platform);

    for (var _i = 0; _i < _count; _i++)
    {
        var _hit = instance_find(obj_platform, _i);
        if (!instance_exists(_hit)) continue;
        if (_is_thin_platform_instance(_hit)) continue;

        if (_right < _hit.bbox_left || _left > _hit.bbox_right) continue;

        var _top = _hit.bbox_top;
        if (_current_bottom < _top && _next_bottom >= _top)
        {
            var _candidate_y = y + ((_top - 1) - _current_bottom);
            if (!_found || _candidate_y < _best_y)
            {
                _best_y = _candidate_y;
                _found = true;
            }
        }
    }

    return _found ? _best_y : undefined;
};

// Повертає Y точного приземлення при перетині верхньої грані thin-платформи
// зверху вниз. Перевірка є swept-перевіркою: вона не залежить від того,
// чи place_meeting() випадково побачив тонку 10px маску на конкретному
// субпіксельному кроці, тому великі швидкості падіння не дають tunnelling.
_thin_landing_y = function(_next_y)
{
    if (_next_y <= y) return undefined;

    var _current_bottom = bbox_bottom;
    var _next_bottom = _current_bottom + (_next_y - y);
    var _left  = bbox_left;
    var _right = bbox_right;

    var _found = false;
    var _best_y = 0;
    var _count = instance_number(obj_thin_platform);

    for (var _i = 0; _i < _count; _i++)
    {
        var _hit = instance_find(obj_thin_platform, _i);
        if (!instance_exists(_hit)) continue;

        // Бокове проходження крізь one-way platform дозволене; приземлення
        // можливе лише коли ширина героя перекриває ширину платформи.
        if (_right < _hit.bbox_left || _left > _hit.bbox_right) continue;

        var _top = _hit.bbox_top;

        // Ноги мають перейти верхню грань саме зверху вниз. Якщо герой уже
        // нижче верхньої грані (зайшов збоку/стрибає знизу), платформа прозора.
        if (_current_bottom < _top && _next_bottom >= _top)
        {
            var _candidate_y = y + ((_top - 1) - _current_bottom);
            if (!_found || _candidate_y < _best_y)
            {
                _best_y = _candidate_y;
                _found = true;
            }
        }
    }

    return _found ? _best_y : undefined;
};

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
    image_xscale = l_right ? 1 : -1;

    // Спочатку встановлюємо нормальний locomotion sprite/mask, а вже потім
    // визначаємо землю. Це робить respawn/load незалежним від death/hurt sprite.
    _set_player_animation(spr_player_idle, 1, true);

    // Аварійне виправлення старих/неточних spawn-точок, що кладуть маску
    // героя на кілька пікселів усередину obj_platform. Без цього vspd кожен
    // кадр обнулявся collision-ом, але jump залишався забороненим.
    var _recover_y = _recover_solid_overlap_y();
    if (!is_undefined(_recover_y))
    {
        y = _recover_y;
        hspd = 0;
        vspd = 0;
        drop_timer = 0;
    }

    grounded = (vspd == 0)
        && (_is_standing_on_solid_platform()
            || (drop_timer <= 0 && _is_standing_on_thin_platform()));

    anim_was_on_ground = grounded;
    anim_was_damage = is_damage;
    anim_last_hp = hp;
    anim_last_x = x;
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
// Кожна метальна зброя має ВЛАСНИЙ obj_trident-екземпляр.
// Це дозволяє одночасно встромити у стіну і тризубець, і спис.
throwable_instances = [noone, noone];
// Сумісність зі старим кодом: alias на поточно вибраний метальний екземпляр.
trident_instance = noone;

_find_throwable = function(_weapon_index, _create_if_missing = false)
{
    if (_weapon_index < 0 || _weapon_index > 1) return noone;

    var _inst = throwable_instances[_weapon_index];
    if (instance_exists(_inst) && _inst.visual_weapon == _weapon_index)
        return _inst;

    _inst = noone;
    var _count = instance_number(obj_trident);
    for (var _i = 0; _i < _count; _i++)
    {
        var _candidate = instance_find(obj_trident, _i);
        if (instance_exists(_candidate)
            && variable_instance_exists(_candidate, "visual_weapon")
            && _candidate.visual_weapon == _weapon_index)
        {
            _inst = _candidate;
            break;
        }
    }

    if (!instance_exists(_inst) && _create_if_missing)
    {
        _inst = instance_create_layer(x, y, "Instances", obj_trident);
        _inst.visual_weapon = _weapon_index;
        _inst.damage = weapon_atk[_weapon_index];
        _inst.owner_player = id;
        _inst.image_xscale = image_xscale;
    }

    throwable_instances[_weapon_index] = _inst;
    if (current_weapon == _weapon_index)
        trident_instance = _inst;

    return _inst;
};

_destroy_throwable_platform = function(_throwable)
{
    if (!instance_exists(_throwable)) return;
    if (variable_instance_exists(_throwable, "platform_instance")
        && instance_exists(_throwable.platform_instance))
    {
        instance_destroy(_throwable.platform_instance);
    }
    _throwable.platform_instance = noone;
};

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

    if (current_weapon <= 1)
    {
        var _t = _find_throwable(current_weapon, false);
        if (instance_exists(_t)
            && (_t.thrown || _t.stuck || point_distance(x, y, _t.x, _t.y) >= 20))
            return false;
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
    current_weapon = _index;

    if (_index <= 1)
        trident_instance = _find_throwable(_index, true);
    else
        trident_instance = noone;

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

    if (current_weapon >= 0 && current_weapon <= 1)
        trident_instance = _find_throwable(current_weapon, false);
    else
        trident_instance = noone;
};

_reset_player_animation();
