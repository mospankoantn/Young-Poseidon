# Меню та налаштування Young Poseidon

Оновлення: 19 вересня 2026 року.

## Реалізація

- Головне меню: нова гра, завантаження, налаштування, автор, вихід.
- Пауза: продовження, збереження, завантаження, налаштування, автор, головне меню, вихід.
- Нова гра за наявності збереження, вихід до меню та закриття гри мають підтвердження. Завантаження недоступне, коли файлу збереження немає.
- Спільні екрани UA/EN. Миша: вибір, перетягування повзунків; клавіатура: стрілки, Enter/Space, Esc. Tab перемикає вкладки опцій.
- Екран автора: Олег Табович; GameMaker/GML; прозоре повідомлення про допомогу ШІ з кодом і графікою.

## Опції

| Вкладка | Реальні параметри |
| --- | --- |
| Екран | Розмір вікна 960x640, 1280x720, 1366x768, 1600x900, 1920x1080, 2560x1440; повноекранний режим; VSync; фільтрація пікселів |
| Звук | Загальна гучність, музика, ефекти, відтворення тестового звуку |
| Керування | Десять літерних дій: ліворуч, праворуч, стрибок, спуск, атака, взаємодія, закриття діалогу, три зілля |
| Гра | Українська/англійська мова, автопауза при втраті фокуса, видимість HUD-підказок |

Кожну вкладку можна скинути окремо. Призначаються літери A-Z, дублікати відхиляються. Стрілки, Esc, Tab, 1-6, колесо миші та пробіл для виходу з вагонетки залишаються штатними альтернативами/службовими діями. Перепризначення основних дій поширюється на гравця, виходи, кнопку, двері, перешкоди, пліт, вагонетку та вибір зброї. HUD зіль і локалізовані підказки виду [E]/[F]/[Q] показують нові літери.

Розмір вікна не змінює фізику, колізійну маску, камеру чи темп гри. GUI залишається логічно 960x640. Завелике вікно пропорційно вписується у доступний робочий стіл. Повноекранний режим використовує роздільність робочого столу, а не перемикає фізичний відеорежим монітора.

Зміни розміру, fullscreen і VSync потребують підтвердження протягом 15 секунд. Таймер використовує реальний час. Esc, тайм-аут або «Повернути попередні» відновлюють старі параметри. До підтвердження у файл записується тільки попередній режим, навіть якщо гра завершується. Вихід із fullscreen перед зміною розміру вікна має затримку 12 кроків відповідно до [вимог GameMaker](https://manual.gamemaker.io/lts/en/GameMaker_Language/GML_Reference/Cameras_And_Display/The_Game_Window/window_set_fullscreen.htm).

## Збереження

Опції: young_poseidon_settings.ini у стандартному каталозі даних GameMaker. Прогрес: окремий young_poseidon_save.ini.

При першому запуску мова переноситься зі старого файлу прогресу. Нова гра, завантаження та смерть не скидають опції. Некоректні значення обмежуються допустимими межами; невідома мова та дубльовані/некоректні клавіші повертаються до стандартних.

## Справжня пауза

obj_ui_controller у Begin Step деактивує активні ігрові екземпляри. На виході активуються тільки ті, які призупинило це меню. Збереження тимчасово відкриває доступ до екземплярів без виконання їхніх Step-подій; перед завантаженням/зміною кімнати гра відновлюється.

Кадр сцени копіюється в Draw GUI, а не поза фазою малювання. Під час паузи резервний буфер дозволяє відновити поверхню після зміни режиму екрана. Cleanup звільняє GPU-поверхню й буфер. Музика меню не накопичує повторні голоси при поверненні з гри.

## Файли та Events

- scripts/scr_settings: валідація, INI, звук, екран, відповідність клавіш.
- scripts/scr_menu_system: спільна навігація, малювання, екрани, підтвердження й пауза.
- obj_main_menu: Create, Step, Draw GUI.
- obj_ui_controller: Create, Begin Step (новий), Step, Draw GUI, Cleanup (новий).
- obj_lang_manager/Create і scr_lang_manager: нове сховище мови, актуальні літери у підказках.
- obj_main_menu_sound: Create, Room End.
- Step споживачів керування: obj_player, obj_comment_zone, obj_interactive_button, obj_mine_cart, obj_olympus_door, obj_raft, obj_room_exit, obj_stalactite, obj_stone_boulder, obj_thicket_platform, obj_weapon_selector.
- Menu_bg: збережено наявні frame/layer GUID, замінено PNG і розміри 1536x1024. Нового дубля спрайта немає.
- Young Poseidon.yyp і resource_order: два нових скрипти; obj_ui_controller.yy: реєстрація двох Events.
- options/windows: назва Young Poseidon, автор Олег Табович.
- README.md, FIXES_APPLIED.txt, Що треба зробити.md: лише актуалізація пунктів цього оновлення.
- tools/import_menu_background.ps1, test_menu_settings.ps1, tests/menu_*: імпорт і перевірки.
- Регресійний тест зброї: test_player_death.ps1 і tests/weapon_visuals_* подають сигнали атаки/повернення лише у тимчасовій копії замість нестабільної емуляції системної клавіатури. У робочому коді тестових гачків немає.

## Перевірка

Runtime: GameMaker 2026.0.0.23, Windows VM. test_menu_settings.ps1 компілює ізольовану копію та запускає Runner двічі з власними абсолютними шляхами до INI; збереження користувача не змінюються.

Перевіряються відкриття екранів, призначення/конфлікти клавіш, відкат екрана, підтверджений розмір після зміни кімнати, заморожування позиції/HP/анімації, збереження й завантаження з паузи, повернення зі вкладених екранів, перезапуск процесу та некоректні INI. Створюються скриншоти UA/EN, віконного й повноекранного режимів; окрема перевірка пікселів відхиляє порожній фон.

Додатково: validate_player_animations.ps1 перевіряє JSON ресурсів і реєстрацію проєкту; test_player_death.ps1 перевіряє відродження; test_weapon_visuals.ps1 перевіряє анімації й бойові сигнали. Автотести не замінюють ручної перевірки реальної клавіатури, різних DPI, моніторів та драйверів.

## Джерело фону

Файл: Файли/Menu_background_clean.png. Згенеровано вбудованим image_gen; використано в наявному Menu_bg. Старий вихідний концепт у Файли не видалено.

Промпт:

> Use case: stylized-concept. Asset: full-screen background for the main menu of Young Poseidon, a pixel-art Greek mythology platformer. Create a polished landscape 3:2 illustration, 1536x1024. Crisp intentional pixel art, not blurry painting. Scene: beautiful turquoise Aegean sea, small rocky island and ancient Greek marble ruins in the middle distance, winding path climbing a spectacular mountain to white Olympus temples in sunlit clouds. Young blue-curly-haired Poseidon in a teal Greek tunic, holding a golden trident, seen from behind on a rock in the lower RIGHT third, looking toward Olympus. Composition: reserve LEFT 40 percent as calm dark teal sea and shadowed coast with little detail for menu text to be overlaid later; place mountain, temples and bright clouds in RIGHT 60 percent. Full-bleed scene, vivid teal water, ivory marble, coral accents and restrained warm golden sunshine. Hero and architecture readable. No text, no letters, no numbers, no labels, no UI, no border, no watermark. This replaces an annotated menu concept image with a clean production game background.
