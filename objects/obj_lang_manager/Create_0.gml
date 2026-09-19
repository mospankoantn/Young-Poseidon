/// @description obj_lang_manager — Create Event

skip_cleanup = false;

// Захист від дублювання (persistent об'єкт)
if (instance_number(obj_lang_manager) > 1)
{
    skip_cleanup = true;
    instance_destroy();
    exit;
}
 
// ════ ПОТОЧНА МОВА ════
// Завантажуємо з ini або ставимо UA за замовчуванням
yp_settings_init();
 
// ════ СЛОВНИК ════
// ds_map: ключ → [UA_текст, EN_текст]
// Доступ: lc("ключ") повертає рядок поточної мови
if (variable_global_exists("lang_db") && ds_exists(global.lang_db, ds_type_map))
    ds_map_destroy(global.lang_db);

global.lang_db = ds_map_create();

// ─────────────────────────────────────
// HUD / UI
// ─────────────────────────────────────
ds_map_add(global.lang_db, "hud_atk",		["АТК",				"ATK"]);
ds_map_add(global.lang_db, "hud_spd",		["ШВ",				"SPD"]);
ds_map_add(global.lang_db, "hud_hp",		["HP",				"HP"]);
ds_map_add(global.lang_db, "hud_no_weapon",	["Без зброї",		"No weapon"]);
ds_map_add(global.lang_db, "hud_key",		["Ключ Олімпу",		"Olympus Key"]);
ds_map_add(global.lang_db, "health",		["Здоров'я",		"Health"]);
 
ds_map_add(global.lang_db, "dialog_player",   ["Ви говорите:",     "You say:"]);
ds_map_add(global.lang_db, "dialog_npc",      ["Підказки / Ворог:","Hints / Enemy:"]);
ds_map_add(global.lang_db, "dialog_e",        ["[E] — говорити",   "[E] — speak"]);
ds_map_add(global.lang_db, "dialog_f",        ["[F] — взаємодіяти","[F] — interact"]);
ds_map_add(global.lang_db, "dialog_next",     ["[Q] Далі ▶",       "[Q] Next ▶"]);
ds_map_add(global.lang_db, "dialog_close",    ["[Q] Закрити ✕",    "[Q] Close ✕"]);
 
// ─────────────────────────────────────
// ГОЛОВНЕ МЕНЮ
// ─────────────────────────────────────
ds_map_add(global.lang_db, "menu_title",      ["YOUNG POSEIDON\nГОЛОВНЕ МЕНЮ",
                                                "YOUNG POSEIDON\nMAIN MENU"]);
ds_map_add(global.lang_db, "menu_start",      ["Почати гру",       "New Game"]);
ds_map_add(global.lang_db, "menu_load",       ["Завантажити гру",  "Load Game"]);
ds_map_add(global.lang_db, "menu_settings",   ["Налаштування",     "Settings"]);
ds_map_add(global.lang_db, "menu_about",      ["Про автора",       "About"]);
ds_map_add(global.lang_db, "menu_exit",       ["Вихід",            "Exit"]);
 
// ─────────────────────────────────────
// МЕНЮ ПАУЗИ
// ─────────────────────────────────────
ds_map_add(global.lang_db, "pause_title",     ["ПАУЗА",            "PAUSED"]);
ds_map_add(global.lang_db, "pause_resume",    ["Продовжити",       "Resume"]);
ds_map_add(global.lang_db, "pause_save",      ["Зберегти гру",     "Save Game"]);
ds_map_add(global.lang_db, "pause_load",      ["Завантажити гру",  "Load Game"]);
ds_map_add(global.lang_db, "pause_settings",  ["Налаштування",     "Settings"]);
ds_map_add(global.lang_db, "pause_mainmenu",  ["Головне меню",     "Main Menu"]);
ds_map_add(global.lang_db, "pause_quit",      ["Вийти з гри",      "Quit Game"]);
ds_map_add(global.lang_db, "save_done",       ["Гру збережено",    "Game saved"]);
ds_map_add(global.lang_db, "autosave_done",   ["Автозбереження виконано", "Autosave complete"]);
ds_map_add(global.lang_db, "save_failed",     ["Не вдалося зберегти гру", "Could not save game"]);
ds_map_add(global.lang_db, "save_unsafe_position", ["Не можна зберегтися всередині стіни або платформи", "Cannot save while inside a wall or platform"]);
ds_map_add(global.lang_db, "load_done",       ["Гру завантажено",  "Game loaded"]);
ds_map_add(global.lang_db, "load_missing",    ["Збереження не знайдено", "No save found"]);
ds_map_add(global.lang_db, "load_corrupt",    ["Файл збереження пошкоджено", "Save file is corrupted"]);
ds_map_add(global.lang_db, "load_incompatible",["Збереження створено новішою версією гри", "Save belongs to a newer game version"]);
 
// ─────────────────────────────────────
// НАЗВИ ЗОН
// ─────────────────────────────────────
ds_map_add(global.lang_db, "zone_sea",        ["Море",             "Sea"]);
ds_map_add(global.lang_db, "zone_coast",      ["Узбережжя",        "Coast"]);
ds_map_add(global.lang_db, "zone_mines",      ["Шахти",            "Mines"]);
ds_map_add(global.lang_db, "zone_hades",      ["Аїд",              "Hades"]);
ds_map_add(global.lang_db, "zone_greece",     ["Греція",           "Greece"]);
ds_map_add(global.lang_db, "zone_battlefield",["Поле Битви",       "Battlefield"]);
ds_map_add(global.lang_db, "zone_olympus",    ["Олімп",            "Olympus"]);
ds_map_add(global.lang_db, "zone_boss",       ["(Бос)",            "(Boss)"]);
 
// ─────────────────────────────────────
// НАЗВИ ЗБРОЇ
// ─────────────────────────────────────
ds_map_add(global.lang_db, "weapon_trident",  ["Тризубець",        "Trident"]);
ds_map_add(global.lang_db, "weapon_spear",    ["Спис",             "Spear"]);
ds_map_add(global.lang_db, "weapon_pickaxe",  ["Кайло",            "Pickaxe"]);
ds_map_add(global.lang_db, "weapon_scythe",   ["Коса",             "Scythe"]);
ds_map_add(global.lang_db, "weapon_oar",      ["Весло",            "Oar"]);
ds_map_add(global.lang_db, "weapon_sword",    ["Меч",              "Sword"]);
 
// ─────────────────────────────────────
// НАЗВИ БОСІВ
// ─────────────────────────────────────
ds_map_add(global.lang_db, "boss_triton",     ["ТРИТОН",           "TRITON"]);
ds_map_add(global.lang_db, "boss_nymph",      ["НІМФА",            "NYMPH"]);
ds_map_add(global.lang_db, "boss_uranus",     ["УРАН",             "URANUS"]);
ds_map_add(global.lang_db, "boss_charon",     ["ХАРОН",            "CHARON"]);
ds_map_add(global.lang_db, "boss_minotaur",   ["МІНОТАВР",         "MINOTAUR"]);
ds_map_add(global.lang_db, "boss_war_ghost",  ["ПРИВИД ВІЙНИ",     "WAR GHOST"]);
ds_map_add(global.lang_db, "boss_moirai",     ["МОЙРИ",            "THE FATES"]);
ds_map_add(global.lang_db, "boss_phase2",     ["— ФАЗА 2 —",       "— PHASE 2 —"]);
 
// ─────────────────────────────────────
// НАЗВИ ВОРОГІВ
// ─────────────────────────────────────
ds_map_add(global.lang_db, "enemy_crab",      ["Гіганський Краб",  "Giant Crab"]);
ds_map_add(global.lang_db, "enemy_harpy",     ["Гарпія-Чайка",     "Harpy Seagull"]);
ds_map_add(global.lang_db, "enemy_miner",     ["Дух Шахтаря",      "Miner Spirit"]);
ds_map_add(global.lang_db, "enemy_shadow",    ["Тінь Аїда",        "Shadow of Hades"]);
ds_map_add(global.lang_db, "enemy_warrior",   ["Грецький Воїн",    "Greek Warrior"]);
ds_map_add(global.lang_db, "enemy_fallen",    ["Дух Полеглого",    "Fallen Spirit"]);
ds_map_add(global.lang_db, "enemy_fire",      ["Вогонь Олімпу",    "Olympus Fire"]);
 
// ─────────────────────────────────────
// ПРЕДМЕТИ
// ─────────────────────────────────────
ds_map_add(global.lang_db, "item_potion_heal",["Зілля Здоров'я",   "Health Potion"]);
ds_map_add(global.lang_db, "item_potion_str", ["Зілля Геракла",    "Hercules Potion"]);
ds_map_add(global.lang_db, "item_potion_spd", ["Зілля Гермеса",    "Hermes Potion"]);
ds_map_add(global.lang_db, "item_ambrosia",   ["Амброзія",         "Ambrosia"]);
ds_map_add(global.lang_db, "item_sandal",     ["Сандаль Гермеса",  "Hermes' Sandal"]);
ds_map_add(global.lang_db, "item_key",        ["Ключ Олімпу",      "Olympus Key"]);
 
// ─────────────────────────────────────
// ПІДКАЗКИ КЕРУВАННЯ
// ─────────────────────────────────────
ds_map_add(global.lang_db, "ctrl_hint",
    ["ESC-Меню | WASD-Рух | S↓-Вниз | E-Кидок | F-Взаємодія | Q-Діалог | Z/X/C-Зілля | 1-6-Зброя",
     "ESC-Menu | WASD-Move | S↓-Drop | E-Throw | F-Interact | Q-Dialog | Z/X/C-Potions | 1-6-Weapon"]);
 
ds_map_add(global.lang_db, "ctrl_tab",
    ["Tab — закрити  |  Enter — обрати",
     "Tab — close  |  Enter — select"]);
 
// ─────────────────────────────────────
// ПЕРЕХОДИ МІЖ КІМНАТАМИ
// ─────────────────────────────────────
ds_map_add(global.lang_db, "exit_go",         ["[F] Перейти",      "[F] Enter"]);
ds_map_add(global.lang_db, "exit_locked",     ["Заблоковано",      "Locked"]);
ds_map_add(global.lang_db, "exit_need",       ["Потрібно: ",       "Required: "]);
 
// Підказки потрібних предметів для виходів
ds_map_add(global.lang_db, "exit_need_pickaxe",
    ["Потрібно: Кайло (перемагай Урана)",
     "Required: Pickaxe (defeat Uranus)"]);
ds_map_add(global.lang_db, "exit_need_scythe",
    ["Потрібно: Коса (перемагай Харона)",
     "Required: Scythe (defeat Charon)"]);
ds_map_add(global.lang_db, "exit_need_oar",
    ["Потрібно: Весло (перемагай Мінотавра)",
     "Required: Oar (defeat Minotaur)"]);
ds_map_add(global.lang_db, "exit_need_key",
    ["Потрібно: Ключ Олімпу (перемагай Мойрів)",
     "Required: Olympus Key (defeat The Fates)"]);
ds_map_add(global.lang_db, "exit_need_sword",
    ["Потрібно: Меч (перемагай Привида)",
     "Required: Sword (defeat War Ghost)"]);
ds_map_add(global.lang_db, "exit_need_spear",
    ["Потрібно: Спис (перемагай Німфу)",
     "Required: Spear (defeat Nymph)"]);
ds_map_add(global.lang_db, "exit_need_trident",
    ["Потрібно: Тризубець (перемагай Тритона)",
     "Required: Trident (defeat Triton)"]);
 
// ─────────────────────────────────────
// ІНТЕРАКТИВНІ ЕЛЕМЕНТИ
// ─────────────────────────────────────
ds_map_add(global.lang_db, "interact_e",      ["[E]",              "[E]"]);
ds_map_add(global.lang_db, "interact_f",      ["[F]",              "[F]"]);
ds_map_add(global.lang_db, "interact_break",  ["[E] Розбити",      "[E] Break"]);
ds_map_add(global.lang_db, "interact_cut",    ["[E] Скосити",      "[E] Cut"]);
ds_map_add(global.lang_db, "interact_sit",    ["[E] Сісти",        "[E] Board"]);
ds_map_add(global.lang_db, "interact_open",   ["[E] Відкрити",     "[E] Open"]);
ds_map_add(global.lang_db, "need_pickaxe",    ["Потрібне кайло",   "Need pickaxe"]);
ds_map_add(global.lang_db, "need_scythe",     ["Потрібна коса",    "Need scythe"]);
ds_map_add(global.lang_db, "need_oar",        ["Потрібне весло",   "Need oar"]);
ds_map_add(global.lang_db, "need_key",        ["Потрібен Ключ Олімпу", "Need Olympus Key"]);
 
// ─────────────────────────────────────
// БАФИ
// ─────────────────────────────────────
ds_map_add(global.lang_db, "buff_atk",
    ["⚡ Геракл +",  "⚡ Hercules +"]);
ds_map_add(global.lang_db, "buff_spd",
    ["💨 Гермес +",  "💨 Hermes +"]);
ds_map_add(global.lang_db, "buff_atk_label",  ["АТК  [",           "ATK  ["]);
ds_map_add(global.lang_db, "buff_spd_label",  ["ШВ  [",            "SPD  ["]);
ds_map_add(global.lang_db, "buff_sec",        ["с]",               "s]"]);
 
// ─────────────────────────────────────
// ДІАЛОГИ ПОСЕЙДОНА (зони коментарів)
// ─────────────────────────────────────
ds_map_add(global.lang_db, "comment_sea_1",
    ["Мій океан... Але попереду чекає Олімп.",
     "My ocean... But Olympus awaits ahead."]);
ds_map_add(global.lang_db, "comment_sea_boss",
    ["Тритоне! Віддай мій тризубець!",
     "Triton! Return my trident!"]);
ds_map_add(global.lang_db, "comment_coast_1",
    ["Суходіл... незвично для бога моря.",
     "Dry land... unusual for a sea god."]);
ds_map_add(global.lang_db, "comment_mines_1",
    ["Тут темно. І пахне старим камінням.",
     "Dark here. Smells of old stone."]);
ds_map_add(global.lang_db, "comment_hades_1",
    ["Царство мертвих... Треба бути обережним.",
     "The realm of the dead... I must be careful."]);
ds_map_add(global.lang_db, "comment_greece_1",
    ["Греція. Вже близько до Олімпу.",
     "Greece. Getting closer to Olympus."]);
ds_map_add(global.lang_db, "comment_battlefield",
    ["Поле битви. Скрізь кістки полеглих.",
     "A battlefield. Bones of the fallen everywhere."]);
ds_map_add(global.lang_db, "comment_olympus_1",
    ["Ось він — Олімп! Я майже дістався!",
     "There it is — Olympus! I'm almost there!"]);
 
// ─────────────────────────────────────
// ДІАЛОГИ БОСІВ (NPC)
// ─────────────────────────────────────
ds_map_add(global.lang_db, "npc_triton",
    ["Ти думаєш що зможеш пройти?! Я — Тритон!",
     "You think you can pass?! I am Triton!"]);
ds_map_add(global.lang_db, "triton_rock_busy",
    ["Зачекай: камінь уже падає!",
     "Wait: a rock is already falling!"]);
ds_map_add(global.lang_db, "triton_rocks_recharging",
    ["Камені скінчилися. Приплив піднімає нову хвилю...",
     "The rocks are gone. The tide is lifting a new wave..."]);
ds_map_add(global.lang_db, "triton_rocks_ready",
    ["Камені знову готові!",
     "The rocks are ready again!"]);
ds_map_add(global.lang_db, "npc_nymph",
    ["Смертний не пройде через мої землі!",
     "No mortal passes through my lands!"]);
ds_map_add(global.lang_db, "npc_uranus",
    ["Хто порушив мій спокій?!",
     "Who dares disturb my rest?!"]);
ds_map_add(global.lang_db, "npc_charon",
    ["Монета за переправу... або смерть.",
     "A coin for the crossing... or death."]);
ds_map_add(global.lang_db, "npc_minotaur",
    ["БУГААА!!!",
     "GRAAAH!!!"]);
ds_map_add(global.lang_db, "npc_war_ghost",
    ["Ця битва ніколи не скінчиться!",
     "This battle will never end!"]);
ds_map_add(global.lang_db, "npc_moirai",
    ["Твоя нитка долі — в наших руках.",
     "The thread of your fate is in our hands."]);
 
// ─────────────────────────────────────
// НАГОРОДИ (текст отримання зброї)
// ─────────────────────────────────────
ds_map_add(global.lang_db, "reward_trident",
    ["Отримано: Тризубець!",      "Obtained: Trident!"]);
ds_map_add(global.lang_db, "reward_spear",
    ["Отримано: Спис!",           "Obtained: Spear!"]);
ds_map_add(global.lang_db, "reward_pickaxe",
    ["Отримано: Кайло!",          "Obtained: Pickaxe!"]);
ds_map_add(global.lang_db, "reward_scythe",
    ["Отримано: Коса!",           "Obtained: Scythe!"]);
ds_map_add(global.lang_db, "reward_oar",
    ["Отримано: Весло!",          "Obtained: Oar!"]);
ds_map_add(global.lang_db, "reward_sword",
    ["Отримано: Меч!",            "Obtained: Sword!"]);
ds_map_add(global.lang_db, "reward_key",
    ["Отримано: Ключ Олімпу!",    "Obtained: Olympus Key!"]);
 
// ─────────────────────────────────────
// FROZEN / СТАТУСИ
// ─────────────────────────────────────
ds_map_add(global.lang_db, "status_frozen",
    ["Заморожено!",   "Frozen!"]);
ds_map_add(global.lang_db, "status_vulnerable",
    ["ВРАЗЛИВИЙ!",    "VULNERABLE!"]);
 
// ─────────────────────────────────────
// ФІНАЛ ГРИ
// ─────────────────────────────────────
ds_map_add(global.lang_db, "ending_title",
    ["Посейдон довів своє право бути богом.",
     "Poseidon proved his right to be a god."]);
ds_map_add(global.lang_db, "ending_subtitle",
    ["Кінець",        "The End"]);
