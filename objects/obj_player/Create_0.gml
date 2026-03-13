/// @description
/// obj_player Create Event

// ════ ЗДОРОВ'Я ════
hp     = 5;
max_hp = 5;
 
// ════ ЗІЛЛЯ ════
potion_heal_count     = 0;
potion_strength_count = 0;
potion_speed_count    = 0;
 
// ════ ХАРАКТЕРИСТИКИ ════
spd            = 1;
perm_spd_bonus = 0;
temp_spd_buff  = 0;
temp_atk_buff  = 0;
buff_duration  = 0;
 
// ════ ФІЗИКА ════
hspd = 0;
vspd = 0;
grv  = 0.5;
 
// ════ СТАН ════
l_right      = true;
is_damage    = false;
is_frozen    = false;
freeze_timer = 0;
 
// ════ ЗБРОЯ ════
// Індекси:  0=Тризубець  1=Спис  2=Кайло  3=Коса  4=Весло  5=Меч
// ------------------------------------------------------------
// Назви зброї
weapon_names    = ["Тризубець", "Спис", "Кайло", "Коса", "Весло", "Меч"];
 
// Іконки зброї (спрайти) — замінити на свої назви спрайтів
weapon_sprites  = [spr_weapon_trident,
                   spr_weapon_spear,
                   spr_weapon_pickaxe,
                   spr_weapon_scythe,
                   spr_weapon_oar,
                   spr_weapon_sword];
 
// Атака кожної зброї
weapon_atk      = [1, 2, 5, 3, 4, 10];
 
// Множник швидкості для кожної зброї
weapon_spd_mult = [1.0, 2.0, 0.25, 1.0, 0.5, 2.0];
 
// Чи розблокована зброя (false = не отримана, не показується)
weapon_unlocked = [true,   // Тризубець — є з початку
                   false,  // Спис — після Німфи
                   false,  // Кайло — після Урана
                   false,  // Коса — після Привида Війни
                   false,  // Весло — після Харона
                   false]; // Меч — після Мінотавра
 
// Поточна обрана зброя
current_weapon = 0;
 
// ════ ТРИЗУБЕЦЬ ════
trident_instance = noone;
 
// ════ КЛЮЧ ОЛІМПУ ════
has_olympus_key = false;   // Отримано після Мойр

// Функція переключення зброї на delta кроків (+1 або -1)
_switch_weapon = function(_delta)
{
    var _start = current_weapon;
    var _next  = current_weapon;
 
    // Шукаємо наступну РОЗБЛОКОВАНУ зброю
    repeat (array_length(weapon_unlocked))
    {
        _next = (_next + _delta + array_length(weapon_unlocked))
                mod array_length(weapon_unlocked);
 
        if (weapon_unlocked[_next])
        {
            current_weapon = _next;
            // audio_play_sound(snd_weapon_switch, 1, false);
            break;
        }
 
        if (_next == _start) break;  // Обійшли всі — жодної не знайдено
    }
};
 
// Функція розблокування зброї (викликається нагородами)
_unlock_weapon = function(_index)
{
    if (_index >= 0 && _index < array_length(weapon_unlocked))
    {
        weapon_unlocked[_index] = true;
        current_weapon          = _index;  // Автоматично переключаємось на нову
        // audio_play_sound(snd_weapon_get, 1, false);
    }
};