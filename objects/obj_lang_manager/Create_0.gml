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
ds_map_add(global.lang_db, "interact_open",   ["[F] Відкрити",     "[F] Open"]);
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


// ─────────────────────────────────────
// ЗАСТАВКИ / CUTSCENES
// ─────────────────────────────────────
ds_map_add(global.lang_db, "cutscene_continue", ["[Q / Space / Enter] — далі", "[Q / Space / Enter] — continue"]);
ds_map_add(global.lang_db, "cutscene_close", ["[Q / Space / Enter] — продовжити", "[Q / Space / Enter] — continue"]);
ds_map_add(global.lang_db, "cutscene_intro_category", ["ПРОЛОГ", "PROLOGUE"]);
ds_map_add(global.lang_db, "cutscene_intro_title", ["Падіння з Олімпу", "The Fall from Olympus"]);
ds_map_add(global.lang_db, "cutscene_intro_body_1", [
    "На вершині Олімпу юний Посейдон заявив свої права на божественний престол. Та Зевс і олімпійці вирішили випробувати його. Без зброї, реліквій і колишньої сили Посейдона скинуто до самого дна океану.",
    "Atop Mount Olympus, young Poseidon claimed his place among the gods. Zeus and the Olympians chose to test him. Stripped of weapons, relics and former power, Poseidon was cast down to the ocean floor."
]);
ds_map_add(global.lang_db, "cutscene_intro_zeus_title", ["Випробування Зевса", "Zeus' Trial"]);
ds_map_add(global.lang_db, "cutscene_intro_body_2", [
    "«Повернися з безодні власними силами. Здолай шлях крізь сім царств і доведи, що гідний Олімпу».\n\nПосейдон підводиться: «Я поверну свою зброю. Я пройду цей шлях і доведу, що моє місце — серед богів».",
    "‘Return from the abyss by your own strength. Cross the seven realms and prove yourself worthy of Olympus.’\n\nPoseidon rises: ‘I will reclaim my weapons. I will make this journey and prove that I belong among the gods.’"
]);

ds_map_add(global.lang_db, "cutscene_outro_category", ["ЕПІЛОГ", "EPILOGUE"]);
ds_map_add(global.lang_db, "cutscene_outro_title", ["Сходження на Олімп", "Ascent to Olympus"]);
ds_map_add(global.lang_db, "cutscene_outro_body", [
    "Двері Олімпу відчинено. Подолавши випробування семи царств, приборкавши стихії та здобувши шість священних знарядь, юний Посейдон робить останній крок до святилища богів. Його ім'я відтепер вкарбовано в історію Олімпу.",
    "The gates of Olympus stand open. Having endured the trials of seven realms, mastered the elements and reclaimed six sacred weapons, young Poseidon takes his final step into the sanctuary of the gods. His name is now carved into the history of Olympus."
]);
ds_map_add(global.lang_db, "cutscene_credits_category", ["ТИТРИ", "CREDITS"]);
ds_map_add(global.lang_db, "cutscene_journey_title", ["Шлях героя", "The Hero's Journey"]);
ds_map_add(global.lang_db, "cutscene_journey_body", [
    "I. Море — Тритон — Тризубець\nII. Узбережжя — Німфа — Спис\nIII. Шахти — Уран — Кайло\nIV. Аїд — Харон — Коса\nV. Греція — Мінотавр — Весло\nVI. Поля битви — Привид війни — Меч\nVII. Олімп — Мойри — Ключ Олімпу",
    "I. Sea — Triton — Trident\nII. Coast — Nymph — Spear\nIII. Mines — Uranus — Pickaxe\nIV. Hades — Charon — Scythe\nV. Greece — Minotaur — Oar\nVI. Battlefield — War Ghost — Sword\nVII. Olympus — The Fates — Key of Olympus"
]);
ds_map_add(global.lang_db, "cutscene_credits_title", ["YOUNG POSEIDON", "YOUNG POSEIDON"]);
ds_map_add(global.lang_db, "cutscene_credits_body", [
    "2D Platformer & Metroidvania\n\nАвтор концепції, геймдизайн, сценарій, програмування та дизайн рівнів: Олег Табович\n\nРушій: GameMaker Studio 2 • Мова: GML\nAI-підтримка: OpenAI ChatGPT та Google Gemini\n\nШлях героя: Море • Узбережжя • Шахти • Аїд • Греція • Поля битви • Олімп\n\nОсоблива подяка спільноті GameMaker, тестувальникам і гравцям.\n© 2026 Young Poseidon.",
    "2D Platformer & Metroidvania\n\nConcept, game design, story, programming and level design: Oleh Tabovych\n\nEngine: GameMaker Studio 2 • Language: GML\nAI assistance: OpenAI ChatGPT and Google Gemini\n\nHero's journey: Sea • Coast • Mines • Hades • Greece • Battlefield • Olympus\n\nSpecial thanks to the GameMaker community, testers and players.\n© 2026 Young Poseidon."
]);

ds_map_add(global.lang_db, "cutscene_biome_category", ["НОВЕ ЦАРСТВО", "NEW REALM"]);
ds_map_add(global.lang_db, "cutscene_biome_sea_title", ["Море — край царства Посейдона", "Sea — Edge of Poseidon's Realm"]);
ds_map_add(global.lang_db, "cutscene_biome_sea_body", ["Глибини знайомі Посейдону, але тепер він беззбройний. Серед коралів і піщаних платформ чатують гігантські краби, а попереду Тритон тримає першу втрачену реліквію.", "The depths are familiar to Poseidon, but now he is unarmed. Giant crabs patrol coral and sand, while Triton guards the first lost relic ahead."]);
ds_map_add(global.lang_db, "cutscene_biome_coast_title", ["Узбережжя — межа двох царств", "Coast — Border of Two Realms"]);
ds_map_add(global.lang_db, "cutscene_biome_coast_body", ["Море залишається позаду. На сонячному березі починається шлях землями Зевса. Тут повітря належить гарпіям-чайкам, а Німфа захищає спис.", "The sea recedes behind you. On the sunlit shore begins the path through Zeus' lands. Harpy gulls rule the air here, and a Nymph guards the spear."]);
ds_map_add(global.lang_db, "cutscene_biome_mines_title", ["Шахти — забуті надра", "Mines — Forgotten Depths"]);
ds_map_add(global.lang_db, "cutscene_biome_mines_body", ["Старі тунелі спускаються крізь камінь. Духи шахтарів бережуть покинуті колії, а прикутий Уран розбиває завали своїм кайлом.", "Old tunnels descend through stone. Miner spirits haunt abandoned rails, while chained Uranus smashes the rubble with his pickaxe."]);
ds_map_add(global.lang_db, "cutscene_biome_hades_title", ["Аїд — царство мертвих", "Hades — Realm of the Dead"]);
ds_map_add(global.lang_db, "cutscene_biome_hades_body", ["Болотний туман ховає дорогу, а тіні не знають жалю. Десь на темній воді Харон чекає зі своєю косою.", "Marsh fog hides the road and the shadows show no mercy. Somewhere upon the dark waters, Charon waits with his scythe."]);
ds_map_add(global.lang_db, "cutscene_biome_greece_title", ["Греція — підніжжя Олімпу", "Greece — Foot of Olympus"]);
ds_map_add(global.lang_db, "cutscene_biome_greece_body", ["Мармурові руїни й дороги героїв ведуть угору. Грецькі воїни не пропускають чужинців, а в лабіринті блукає Мінотавр з веслом.", "Marble ruins and roads of heroes lead upward. Greek warriors bar the way, while the Minotaur roams his labyrinth with an oar."]);
ds_map_add(global.lang_db, "cutscene_biome_battlefield_title", ["Поля битви — царство Ареса", "Battlefield — Realm of Ares"]);
ds_map_add(global.lang_db, "cutscene_biome_battlefield_body", ["Тут війна не закінчилась навіть після смерті. Духи полеглих підводяться знову, підкоряючись Привиду війни.", "Here war did not end with death. Fallen spirits rise again at the command of the War Ghost."]);
ds_map_add(global.lang_db, "cutscene_biome_olympus_title", ["Олімп — дім богів", "Olympus — Home of the Gods"]);
ds_map_add(global.lang_db, "cutscene_biome_olympus_body", ["Вершина вже близько. Золоті храми стоять над хмарами, але нитка долі ще в руках Мойрів. За ними — брама Олімпу.", "The summit is near. Golden temples rise above the clouds, but the thread of fate remains in the hands of the Fates. Beyond them waits the gate of Olympus."]);

ds_map_add(global.lang_db, "cutscene_reward_category", ["НАГОРОДА БОСА", "BOSS REWARD"]);
ds_map_add(global.lang_db, "cutscene_weapon_trident_title", ["Тризубець повернено", "Trident Reclaimed"]);
ds_map_add(global.lang_db, "cutscene_weapon_trident_body", ["АТК 1 • Швидкість 1\n[E] — кинути. Тризубець застрягає в стіні та стає платформою. [F] — покликати його назад у руки.", "ATK 1 • Speed 1\n[E] — throw. The trident sticks into walls and becomes a platform. [F] — recall it to your hand."]);
ds_map_add(global.lang_db, "cutscene_weapon_spear_title", ["Спис Німфи", "Nymph's Spear"]);
ds_map_add(global.lang_db, "cutscene_weapon_spear_body", ["АТК 2 • Швидкість 2\n[E] — кинути. Спис також можна встромити в стіну як платформу. [F] — повернути вибрану метальну зброю.", "ATK 2 • Speed 2\n[E] — throw. The spear can also be embedded in a wall as a platform. [F] — recall the selected throwable weapon."]);
ds_map_add(global.lang_db, "cutscene_weapon_pickaxe_title", ["Кайло Урана", "Uranus' Pickaxe"]);
ds_map_add(global.lang_db, "cutscene_weapon_pickaxe_body", ["АТК 5 • Швидкість 0.25\nВажке, але потужне. [E] атакує та розбиває кам'яні брили, що перекривають шлях.", "ATK 5 • Speed 0.25\nHeavy but powerful. [E] attacks and breaks stone boulders blocking the path."]);
ds_map_add(global.lang_db, "cutscene_weapon_scythe_title", ["Коса Харона", "Charon's Scythe"]);
ds_map_add(global.lang_db, "cutscene_weapon_scythe_body", ["АТК 3 • Швидкість 1\n[E] атакує та скошує зарослі хащами платформи, відкриваючи нові маршрути.", "ATK 3 • Speed 1\n[E] attacks and cuts overgrown thickets, opening new routes."]);
ds_map_add(global.lang_db, "cutscene_weapon_oar_title", ["Весло Мінотавра", "Minotaur's Oar"]);
ds_map_add(global.lang_db, "cutscene_weapon_oar_body", ["АТК 4 • Швидкість 0.5\nВикористовується як важка зброя і дозволяє керувати плотами на воді.", "ATK 4 • Speed 0.5\nA heavy weapon that also lets Poseidon control rafts on water."]);
ds_map_add(global.lang_db, "cutscene_weapon_sword_title", ["Меч Привида війни", "War Ghost's Sword"]);
ds_map_add(global.lang_db, "cutscene_weapon_sword_body", ["АТК 10 • Швидкість 2\nНайнебезпечніша зброя ближнього бою. [E] виконує стрімкий випад уперед.", "ATK 10 • Speed 2\nThe deadliest melee weapon. [E] performs a fast forward lunge."]);
ds_map_add(global.lang_db, "cutscene_weapon_key_title", ["Ключ Олімпу", "Key of Olympus"]);
ds_map_add(global.lang_db, "cutscene_weapon_key_body", ["Мойри переможені. Цей ключ відчиняє останню браму до святилища богів. Шлях Посейдона майже завершено.", "The Fates are defeated. This key opens the final gate to the sanctuary of the gods. Poseidon's journey is almost complete."]);

// ─────────────────────────────────────
// КОНТЕКСТНІ ПІДКАЗКИ / TUTORIAL HINTS
// ─────────────────────────────────────
ds_map_add(global.lang_db, "hint_basic_move", ["[A]/[D] — рух. [W] — стрибок. Досліджуй шлях до Олімпу.", "[A]/[D] — move. [W] — jump. Explore the road to Olympus."]);
ds_map_add(global.lang_db, "hint_thin_platform", ["На тонкі платформи можна застрибувати знизу та збоку. [S] — спригнути крізь них вниз.", "You can jump through thin platforms from below or the side. [S] — drop down through them."]);
ds_map_add(global.lang_db, "hint_crab", ["Гіганський краб атакує дотиком. Поки ти без зброї — тримай дистанцію.", "The Giant Crab attacks on contact. Until you find a weapon, keep your distance."]);
ds_map_add(global.lang_db, "hint_checkpoint", ["Чекпоінт зберігає безпечне місце відродження та створює автозбереження.", "A checkpoint stores a safe respawn point and creates an autosave."]);
ds_map_add(global.lang_db, "hint_potion_heal", ["Отримано цілюще зілля. [Z] — відновити здоров'я.", "Health potion obtained. [Z] — restore health."]);
ds_map_add(global.lang_db, "hint_potion_strength", ["Отримано зілля Геракла. [X] — тимчасово збільшити силу атаки.", "Hercules potion obtained. [X] — temporarily increase attack power."]);
ds_map_add(global.lang_db, "hint_potion_speed", ["Отримано зілля Гермеса. [C] — тимчасово збільшити швидкість.", "Hermes potion obtained. [C] — temporarily increase speed."]);
ds_map_add(global.lang_db, "hint_ambrosia", ["Амброзія назавжди збільшує максимальне HP на 1 і повністю лікує.", "Ambrosia permanently increases maximum HP by 1 and fully heals you."]);
ds_map_add(global.lang_db, "hint_sandal", ["Сандаль Гермеса назавжди збільшує швидкість Посейдона.", "Hermes' Sandal permanently increases Poseidon's speed."]);
ds_map_add(global.lang_db, "hint_triton_button", ["[E] — активувати механізм і скинути камінь на Тритона.", "[E] — activate the mechanism and drop a rock on Triton."]);
ds_map_add(global.lang_db, "hint_throw_return", ["[E] — кинути тризубець/спис. Якщо зброя застрягла в стіні, [F] — покликати її назад.", "[E] — throw the trident/spear. If it is stuck in a wall, [F] — recall it."]);
ds_map_add(global.lang_db, "hint_recall_first", ["Зброя не в руках. Спочатку натисни [F], дочекайся повернення, а тоді кидай знову.", "The weapon is not in your hand. Press [F], wait for it to return, then throw again."]);
ds_map_add(global.lang_db, "hint_weapon_switch", ["[1-6] або колесо миші — перемикання між відкритою зброєю.", "[1-6] or the mouse wheel — switch between unlocked weapons."]);
ds_map_add(global.lang_db, "hint_mine_cart", ["[E] — сісти у вагонетку. [A]/[D] — рух рейками. [E] або стрибок — вийти.", "[E] — enter the mine cart. [A]/[D] — move on rails. [E] or jump — exit."]);
ds_map_add(global.lang_db, "hint_raft", ["Екіпіруй Весло, стань на пліт і керуй ним, щоб перетнути воду.", "Equip the Oar and stand on the raft to navigate across water."]);
ds_map_add(global.lang_db, "hint_boulder", ["Кам'яні брили блокують шлях. Екіпіруй Кайло та атакуй [E], щоб розбити їх.", "Stone boulders block the way. Equip the Pickaxe and attack with [E] to break them."]);
ds_map_add(global.lang_db, "hint_thicket", ["Зарослі хащі можна скосити Косою [E], відкривши прохід.", "Overgrown thickets can be cut with the Scythe [E] to open the path."]);
ds_map_add(global.lang_db, "hint_stalactite", ["Сталактит можна розбити Кайлом. Падаюче каміння шкодить і Харону, і Посейдону.", "Break stalactites with the Pickaxe. Falling rocks can hurt both Charon and Poseidon."]);
ds_map_add(global.lang_db, "hint_minotaur_column", ["Колони дають укриття від Мінотавра, але руйнуються після повторних ударів.", "Columns provide cover from the Minotaur, but repeated blows will destroy them."]);
ds_map_add(global.lang_db, "hint_olympus_door", ["Останню браму можна відкрити Ключем Олімпу. Підійдіть до неї та натисніть [F].", "The final gate opens with the Key of Olympus. Approach it and press [F]."]);
ds_map_add(global.lang_db, "hint_room_exit", ["[F] біля стрілки переходу — перейти до сусідньої кімнати.", "[F] near a route arrow — travel to the adjacent room."]);
