/// @description 

// --- КЕРУВАННЯ --- 
var _a = keyboard_check(ord("A"));
var _d = keyboard_check(ord("D"));
var _f_pressed = keyboard_check_pressed(ord("F")); // Кидок тризубця
var _1_pressed = keyboard_check_pressed(ord("1")); // Повернення тризубця зі стіни
var _space_pressed = keyboard_check_pressed(vk_space); // Стрибок
var _2_pressed = keyboard_check_pressed(ord("2")); // Використати зілля здоров'я
var _3_pressed = keyboard_check_pressed(ord("3")); // Використати зілля сили
var _4_pressed = keyboard_check_pressed(ord("4")); // Використати зілля швидкості

// --- РУХ --- 
var _move = _d - _a;

// Обчислення поточної швидкості з урахуванням бонусів
var _current_spd = spd + perm_spd_bonus + temp_spd_buff;

var _hspd = _move * _current_spd * 10;
vspd = vspd + grv;

// Визначаємо в яку сторону дивиться гравець
if (_move != 0) // Оновлюємо напрямок тільки при русі
{
	if (_move > 0)
	{
		l_right = true;
		l_left = false;
		image_xscale = 1;
	}
	else
	{
		l_right = false;
		l_left = true;
		image_xscale = -1;
	}
}


// --- ЗІТКНЕННЯ З ПЛАТФОРМАМИ --- 
// Перевірка по горизонталі
if (place_meeting(x + _hspd, y, obj_platform))
{
	// Переміщення до зіткнення
	while(!place_meeting(x + sign(_hspd), y, obj_platform))
	{
		x += sign(_hspd);
	}
	_hspd = 0; // Зупинка горизонтального руху
}
x += _hspd; // Пересуваємо по горизонталі

// Стрибок (тільки якщо на землі)
if (place_meeting(x, y + 1, obj_platform) && _space_pressed)
{
	audio_play_sound(snd_jump, 1, false); // Переконайтесь, що snd_jump існує
	vspd = -10; // Сила стрибка
}

// Перевірка по вертикалі
if (place_meeting(x, y + vspd, obj_platform))
{
	// Переміщення до зіткнення
	while(!place_meeting(x, y + sign(vspd), obj_platform))
	{
		y += sign(vspd);
	}
	vspd = 0; // Зупинка вертикального руху
}
y += vspd; // Пересуваємо по вертикалі


// --- ТРИЗУБЕЦЬ --- 

// Спрощена логіка: знаходимо тризубець і кидаємо його
if (trident_instance == noone || !instance_exists(trident_instance))
{
	// Шукаємо тризубець (навіть якщо деактивований)
	trident_instance = instance_find(obj_trident, 0);
	if (!instance_exists(trident_instance))
	{
		// Якщо немає - виходимо
		_f_pressed = false;
	}
}

// Перед кидком проверяємо тризубець
if (_f_pressed && instance_exists(trident_instance))
{
	// Якщо застрягнув, звільняємо його
	if (trident_instance.stuck)
	{
		trident_instance.stuck = false;
		// Видалити всі платформи, пов'язані з тризубцем
		var _platform_count = instance_number(obj_trident_platform);
		for (var _i = 0; _i < _platform_count; _i++)
		{
			var _plat = instance_find(obj_trident_platform, _i);
			if (instance_exists(_plat))
			{
				instance_destroy(_plat);
			}
		}
	}
	
	// Кидаємо тризубець, якщо він не летить і не застряг
	if (!trident_instance.thrown && !trident_instance.stuck)
	{
		// Запускаємо кидок
		trident_instance.thrown = true;
		trident_instance.timer = 0;
		trident_instance.x = x + (image_xscale * 20);
		trident_instance.y = y;
		trident_instance.image_xscale = image_xscale;
	}
}

// Повернення тризубця зі стіни (1)
if (_1_pressed)
{
    var _trident_platform = instance_place(x, y, obj_trident_platform);
    if (instance_exists(_trident_platform))
    {
        with (_trident_platform)
        {
            // Знаходимо тризубець
            var _original_trident = instance_find(obj_trident, 0);
            if (instance_exists(_original_trident))
            {
                instance_activate_object(_original_trident);
                _original_trident.invisible_time = true;
                _original_trident.thrown = false;
                _original_trident.stuck = false;
                _original_trident.alarm[0] = 15;
                _original_trident.image_angle = 0;
                obj_player.trident_instance = _original_trident;
            }
            instance_destroy();
        }
    }
}


// --- ЗДОРОВ'Я ТА СМЕРТЬ --- 
if (hp <= 0)
{
	game_restart(); // Або перехід до екрану смерті
}

// --- БАФИ ТА НЕВРАЗЛИВІСТЬ --- 

// Таймер невразливості після отримання шкоди
if (is_damage)
{
	// Тут можна додати ефект блимання спрайту
	// image_alpha = 0.5 + sin(get_timer()/100000)*0.5;
	
	// Таймер працює в події Alarm[0]
}
else
{
	// image_alpha = 1; // Повернення нормальної прозорості
}

// Таймер для тимчасових бафів
if (buff_duration > 0)
{
	buff_duration--;
	if (buff_duration <= 0)
	{
		// Скидання тимчасових бафів
		temp_spd_buff = 0;
		temp_atk_buff = 0;
		// Можливо, додати візуальний ефект завершення бафу
	}
}

// --- ВИКОРИСТАННЯ ЗІЛЛЯ --- 

// Зілля здоров'я (2)
if (_2_pressed && potion_heal_count > 0)
{
	if (hp < max_hp) // Перевірка, чи не повне здоров'я
	{
		hp = min(hp + 2, max_hp); // Відновлює 2 HP, але не більше max_hp
		potion_heal_count--;
		// Додати звук використання зілля
		// Додати візуальний ефект
	}
}

// Зілля сили (3)
if (_3_pressed && potion_strength_count > 0 && buff_duration <= 0) // Не можна використовувати, якщо вже є активний баф
{
	potion_strength_count--;
	temp_atk_buff = 1; // Наприклад, додає +1 до шкоди
	buff_duration = room_speed * 10; // Тривалість бафу 10 секунд
	// Додати звук та ефект бафу
}

// Зілля швидкості (4)
if (_4_pressed && potion_speed_count > 0 && buff_duration <= 0) // Не можна використовувати, якщо вже є активний баф
{
	potion_speed_count--;
	temp_spd_buff = 1; // Наприклад, додає +1 до швидкості
	buff_duration = room_speed * 10; // Тривалість бафу 10 секунд
	// Додати звук та ефект бафу
}




