/// @description 

// Перевірка наявності гравця
if (!instance_exists(obj_player)) exit; // Вийти, якщо гравець не існує

var _interaction_button = ord("E");
var _direction_to_player = point_direction(x, y, obj_player.x, obj_player.y);

// --- ЗІТКНЕННЯ --- 

// Зіткнення зі стіною (платформою) - тільки коли летить
if (place_meeting(x, y, obj_platform) && !invisible_time && thrown) 
{
	stuck = true;
	thrown = false;
	timer = 0; // Скидаємо таймер
	
	// Створення платформи-тризубця
	var _platform = instance_create_layer(x, y, "Instances", obj_trident_platform);
	_platform.image_xscale = image_xscale;
	
	// Залишаємо тризубець активним для F-кидка
	exit; // Виходимо з події Step
}
	
// Зіткнення з ворогом
if (thrown) // Шкода завдається тільки під час польоту
{
	var _enemy_hit = instance_place(x, y, obj_enemy);
	if (instance_exists(_enemy_hit))
	{
		with (_enemy_hit) 
		{
			// Обчислення поточної шкоди тризубця (базова + баф гравця)
			var _current_trident_damage = other.damage + obj_player.temp_atk_buff;
			
			// Завдати шкоди ворогу
			hp -= _current_trident_damage; 
			// Можна додати ефект удару, звук
		}
		thrown = false; // Тризубець зупиняє політ після влучання
		timer = 0;
		// Не деактивуємо, він почне повертатися до гравця
	}
}

// --- СТАНИ РУХУ --- 

// 1. Повернення до гравця (не кинутий, не застряг)
if (!thrown && !stuck)
{
	// Рухаємось до гравця
	var _dist = point_distance(x, y, obj_player.x, obj_player.y);
	if (_dist > speed) // Рухатись, якщо відстань більша за швидкість кроку
	{
		move_towards_point(obj_player.x, obj_player.y, speed);
		image_angle = point_direction(x, y, obj_player.x, obj_player.y);
	}
	else
	{
		// Якщо дуже близько, залишаємось з гравцем
		x = obj_player.x;
		y = obj_player.y;
		// НЕ деактивуємо! Залишаємо активним, щоб F працював
		obj_player.trident_instance = self;
	}
}

// 2. Політ після кидка (кинутий, не застряг)
if (thrown && !stuck) 
{
    // Рух у напрямку, в якому кидок був здійснений
	var _fly_direction = image_xscale > 0 ? 0 : 180; // 0 = вправо, 180 = вліво
	
	// Рух тризубця
	x += lengthdir_x(speed, _fly_direction);
	y += lengthdir_y(speed, _fly_direction);
	
	image_angle = 0; // Тризубець летить рівно
	timer++;
	
	// Перевірка виходу за границі кімнати - повертаємо тризубець
	if (x < -50 || x > room_width + 50 || y < -50 || y > room_height + 50)
	{
		thrown = false;
		timer = 0;
		return; // Вийти з цього блоку і почати повертатися
	}
	
    // Перевірка завершення польоту за часом
    if (timer >= flight_duration_limit) 
	{
        thrown = false;
		timer = 0;
    }
} 

