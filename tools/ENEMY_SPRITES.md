# Спрайти ворогів і босів

14 аркушів 1254x1254 PNG із прозорим фоном. Кожен містить чотири
ряди по чотири кадри: idle, move, attack, death. Межі кадрів
обчислюються за альфа-каналом кожного аркуша окремо. Ресурси створено
з чинного шаблону GMSprite v2 / resourceVersion 2.0; об'єкти зберігають
спрайт spr_giant_crab як колізійну маску.

| Джерело в `Файли` | GameMaker спрайти | Об'єкт |
| --- | --- | --- |
| Графіка/Вороги/Спрайти Краба.png | spr_giant_crab_{idle,move,attack,death} | obj_giant_crab |
| Графіка/Вороги/Sprites obj_harpy_seagull.png | spr_harpy_seagull_{idle,move,attack,death} | obj_harpy_seagull |
| Графіка/Вороги/Sprites obj_miner_spirit.png | spr_miner_spirit_{idle,move,attack,death} | obj_miner_spirit |
| Графіка/Вороги/Sprites obj_hades_shadow.png | spr_hades_shadow_{idle,move,attack,death} | obj_hades_shadow |
| Графіка/Вороги/Sprites obj_greek_warrior.png | spr_greek_warrior_{idle,move,attack,death} | obj_greek_warrior |
| Графіка/Вороги/Sprites obj_fallen_spirit.png | spr_fallen_spirit_{idle,move,attack,death} | obj_fallen_spirit |
| Графіка/Вороги/Sprites obj_olympus_fire.png | spr_olympus_fire_{idle,move,attack,death} | obj_olympus_fire |
| Графіка/Боси/Sprites obj_boss_triton.png | spr_boss_triton_{idle,move,attack,death} | obj_boss_triton |
| Графіка/Боси/Sprites obj_boss_nymph.png | spr_boss_nymph_{idle,move,attack,death} | obj_boss_nymph |
| Графіка/Боси/Sprites obj_boss_uranus.png | spr_boss_uranus_{idle,move,attack,death} | obj_boss_uranus |
| Графіка/Боси/Sprites obj_boss_charon.png | spr_boss_charon_{idle,move,attack,death} | obj_boss_charon |
| Графіка/Боси/Sprites obj_boss_minotaur.png | spr_boss_minotaur_{idle,move,attack,death} | obj_boss_minotaur |
| Графіка/Боси/Sprites obj_boss_war_ghost.png | spr_boss_war_ghost_{idle,move,attack,death} | obj_boss_war_ghost |
| Графіка/Боси/Sprites obj_boss_moirai.png | spr_boss_moirai_{idle,move,attack,death} | obj_boss_moirai |

На цих аркушах немає окремого ряду hurt. Четвертий ряд — послідовність
пошкодження та смерті, відтворювана одноразово перед існуючим
знищенням або появою нагороди. Решта PNG у `Файли` стосуються
гравця, оточення або референсів рівнів; їх не прив'язували до ворогів.


## Поточні бойові уточнення

- `obj_arrow` нормалізує `(direction_x, direction_y)`, тому може летіти не лише горизонтально.
- Німфа створює стріли з `direction_x = 0`, `direction_y = 1` і `damage = atk`; її залп має летіти вниз та завдавати 2 базової шкоди з урахуванням invulnerability гравця.
- `spr_giant_crab_mask` має власний компактний bbox; валідатор додатково перевіряє composite/layer PNG, щоб GameMaker не показував `File missing for GMSprite`.

Перевірки з кореня проєкту:

```powershell
./tools/validate_enemy_sheets.ps1
./tools/test_enemy_animations.ps1
```

Імпорт можна повторити командою `./tools/import_enemy_sheets.ps1`.
Остання перевірка: 14 відповідностей, 56 GMSprite ресурсів, 224 кадри,
frame/layer PNG і ресурсні посилання. Раніше цей набір проходив компіляцію GameMaker/Runner для 14 об'єктів; після поточних правок Німфи/стріл і mask-layer repair у цьому середовищі виконано лише статичну перевірку, тому Runner треба повторити локально.
