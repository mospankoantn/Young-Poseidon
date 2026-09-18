# Графіка зброї та снарядів

## Джерела й відповідність

Усі шість наданих PNG мають розмір 1254 × 1254. Межі рядків і колонок
перевірені за зображеннями; це не рівномірна сітка. Координати імпорту
записані в weapon_visuals_manifest.json. Оригінали не змінені.

| PNG у Файли | Іконка / нагорода | Анімації obj_player |
| --- | --- | --- |
| Sprite examples trident.png | spr_weapon_trident / obj_pickup_trident_reward | spr_player_trident_* |
| Sprite examples spear.png | spr_weapon_spear / obj_pickup_spear_reward | spr_player_spear_* |
| Sprite examples pickaxe .png | spr_weapon_pickaxe / obj_pickup_pickaxe_reward | spr_player_pickaxe_* |
| Sprite examples scythe.png | spr_weapon_scythe / obj_pickup_scythe_reward | spr_player_scythe_* |
| Sprite examples oar.png | spr_weapon_oar / obj_pickup_oar_reward | spr_player_oar_* |
| Sprite examples sword.png | spr_weapon_sword / obj_pickup_sword_reward | spr_player_sword_* |

Для всіх видів зброї імпортовані idle, run, pickup, attack.
Для тризубця й списа також cast і recall; для інших чотирьох видів special.
Перемикання зброї скасовує попередню анімацію дії.
Усі кадри гравця мають прозоре поле 160 × 128 з origin (80, 104);
положення стоп і розмір тіла узгоджені, колізійна маска залишається spr_player.
Біг використовує три вихідні пози в послідовності 5, 6, 7, 6.

## Прив'язка до дій

- Підбір нагороди: pickup; спокій і біг по землі: відповідні idle/run.
- E з тризубцем/списом: cast, F при поверненні: recall.
- E з мечем, кайлом, косою або веслом: attack.
- Руйнування валуна/сталактита кайлом, зрізання хащів косою: special.
- Керування плотом з веслом: special.
- Імпортовані melee-attack тризубця/списа та special меча залишені доступними
  ресурсами, але нові бойові механіки для них не додавалися.
- Стрибок, приземлення, пошкодження та смерть використовують попередні загальні
  анімації: відповідних озброєних поз у цих джерелах немає.
- Кинута/застрягла зброя не дублюється у grounded idle/run гравця.
  Окремий намальований снаряд у кадрі кидка вилучено з області персонажа.

## Нагороди та снаряди

Існуючі шість spr_weapon_* оновлені, а не продубльовані.
spr_olympus_key оновлений і підключений до obj_pickup_olympus_key.
Батьківський obj_pickup_weapon_base зберігає спільні підбір і малювання;
абстрактному obj_pickup не присвоєно чужу іконку, щоб не змінити зілля.
Для нагород та obj_trident збережена стара геометрія через spr_weapon_collision.
obj_trident_platform також використовує стару маску 32 × 10; її дублювальний
Draw вимкнений, бо застряглу зброю малює obj_trident.

| Object | Графіка | Маска |
| --- | --- | --- |
| obj_trident | spr_projectile_trident / spr_projectile_spear за видом кинутої зброї | spr_weapon_collision |
| obj_proj_water_ball | spr_projectile_water | spr_test_proj |
| obj_proj_coin | spr_projectile_coin | spr_test_proj |
| obj_proj_spear_ghost | spr_projectile_ghost_spear | spr_test_arrow |
| obj_proj_fate_beam | spr_projectile_fate | spr_test_arrow |
| obj_proj_lightning | spr_projectile_lightning + попереджувальне коло | spr_test_proj |
| obj_charon_scythe | spr_projectile_scythe | spr_test_arrow |

Для ключа й п'яти ефектів створений додатковий прозорий атлас
Файли/weapon_projectile_effects_source.png через imagegen:
4 колонки, 6 рядків, чотири кадри водяної кулі, золотої монети,
примарного списа вправо, пурпурної нитки долі вправо, вертикальної блискавки
та ключа Олімпу. Іконки зброї й фізичні метальні спрайти взято з наданих PNG.
Час і радіус удару блискавки, шкода, швидкості та поведінка снарядів не змінені.
obj_arrow залишається зі старою графікою.

## Перевірки й відтворення

PowerShell 7 на Windows:

    ./tools/import_weapon_visuals.ps1
    ./tools/connect_weapon_visuals.ps1
    ./tools/preview_weapon_effects.ps1
    ./tools/validate_weapon_visuals.ps1
    ./tools/validate_player_animations.ps1
    ./tools/test_weapon_visuals.ps1
    ./tools/test_player_death.ps1

Імпорт повторно використовує імена ресурсів та GUID існуючих кадрів.
Нові анімації розташовані в Спрайты/Player/Weapons за видами зброї;
снаряди в Спрайты/Effects/Projectiles.
Валідатор перевіряє 48 пов'язаних спрайтів і 130 кадрів, YY/YYP, resourceType,
resourceVersion, посилання, sequence/tracks, PNG/layers і межі кадрів.
Тести збирають ізольовану копію та запускають Runner GameMaker 2026.0.0.23.
Це автоматичні сценарії, а не повне ручне проходження гри.

Змінені Events: obj_player Create/Step/End Step; Create семи нагород;
Draw/Step obj_pickup_weapon_base; Create/Draw obj_trident; Create obj_proj_coin;
Draw obj_proj_fate_beam/obj_proj_lightning; Step obj_stone_boulder,
obj_stalactite, obj_thicket_platform, obj_raft; Draw GUI obj_ui_controller
та obj_weapon_selector. Також оновлені spriteId/spriteMaskId відповідних Objects,
спрайти, Young Poseidon.yyp, Young Poseidon.resource_order і тестові інструменти.
