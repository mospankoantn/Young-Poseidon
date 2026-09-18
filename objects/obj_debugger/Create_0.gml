
/// @description obj_debugger — Create Event

if (instance_number(obj_debugger) > 1)
{
    instance_destroy();
    exit;
}

// ════ СТАН ════
is_open       = false;   // F1 = відкрити/закрити
active_tab    = 0;       // 0=Карта, 1=Гравець, 2=Вороги, 3=Предмети

// ════ СПИСОК КІМНАТ ════
// Кожен запис: [назва, room_resource]
room_list = [
    ["── МОРЕ ──",              -1],
    ["Море 1",                  rm_sea_1],
    ["Море 2",                  rm_sea_2],
    ["Море 3 (Бос: Тритон)",    rm_sea_3],
    ["Море 4",                  rm_sea_4],
    ["Море 5",                  rm_sea_5],
    ["── УЗБЕРЕЖЖЯ ──",         -1],
    ["Узбережжя 1",             rm_coast_1],
    ["Узбережжя 2",             rm_coast_2],
    ["Узбережжя 3",             rm_coast_3],
    ["Узбережжя 4",             rm_coast_4],
    ["Узбережжя 5 (Бос: Німфа)",rm_coast_5],
    ["── ШАХТИ ──",             -1],
    ["Шахти 1",                 rm_mines_1],
    ["Шахти 2",                 rm_mines_2],
    ["Шахти 3",                 rm_mines_3],
    ["Шахти 4 (Бос: Уран)",     rm_mines_4],
    ["Шахти 5",                 rm_mines_5],
    ["── АЇД ──",               -1],
    ["Аїд 1",                   rm_hades_1],
    ["Аїд 2",                   rm_hades_2],
    ["Аїд 3",                   rm_hades_3],
    ["Аїд 4",                   rm_hades_4],
    ["Аїд 5 (Бос: Харон)",      rm_hades_5],
    ["── ГРЕЦІЯ ──",            -1],
    ["Греція 1",                rm_greece_1],
    ["Греція 2",                rm_greece_2],
    ["Греція 3",                rm_greece_3],
    ["Греція 4 (Бос: Мінотавр)",rm_greece_4],
    ["Греція 5",                rm_greece_5],
    ["── ПОЛЕ БИТВИ ──",        -1],
    ["Поле Битви 1",            rm_battlefield_1],
    ["Поле Битви 2",            rm_battlefield_2],
    ["Поле Битви 3",            rm_battlefield_3],
    ["Поле Битви 4",            rm_battlefield_4],
    ["Поле Битви 5 (Бос: Привид)",rm_battlefield_5],
    ["── ОЛІМП ──",             -1],
    ["Олімп 1",                 rm_olympus_1],
    ["Олімп 2",                 rm_olympus_2],
    ["Олімп 3",                 rm_olympus_3],
    ["Олімп 4",                 rm_olympus_4],
    ["Олімп 5 (Бос: Мойри)",    rm_olympus_5],
];

room_scroll   = 0;       // Скрол списку кімнат
room_hover    = -1;      // Поточна кімната під курсором

// ════ ВКЛАДКА ГРАВЦЯ ════
show_hitbox   = false;
show_velocity = false;
god_mode      = false;
fast_mode     = false;

// ════ ЖУРНАЛ ПОДІЙ ════
log_messages  = [];
log_max       = 8;

// ════ FPS ════
fps_history   = array_create(60, 60);
fps_index     = 0;

// ════ ПОЗИЦІЯ ПАНЕЛІ ════
panel_x = 10;
panel_y = 10;
panel_w = 320;
panel_h = 520;

// ════ ФУНКЦІЯ ЛОГУ ════
debug_log = function(_msg)
{
    array_insert(log_messages, 0, _msg);
    if (array_length(log_messages) > log_max)
        array_delete(log_messages, log_max, 1);
};

// Функція режимів (оголоси у Create Event):
_apply_modes = function()
{
    if (!instance_exists(obj_player)) exit;

    // God Mode — гравець не може отримати шкоду
    if (god_mode)
    {
        obj_player.is_damage = true;    // Завжди невразливий
        obj_player.hp        = obj_player.max_hp;
    }

    // Fast Mode — x3 швидкість
    if (fast_mode)
        game_set_speed(180, gamespeed_fps);
    else
        game_set_speed(60, gamespeed_fps);
};
