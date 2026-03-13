/// @description Логіка поведінки крабу
// obj_giant_crab Step Event

// Швидкість руху крабу
if (!variable_instance_exists(id, "move_speed"))
{
	move_speed = 2;
	move_left = true;
	left_bound = x - 100;
	right_bound = x + 100;
	attack_cooldown = 0;
	animation_counter = 0;
}

// Переміщення вліво-вправо
if (move_left)
{
	x -= move_speed;
	image_xscale = -1;
	if (x <= left_bound)
		move_left = false;
}
else
{
	x += move_speed;
	image_xscale = 1;
	if (x >= right_bound)
		move_left = true;
}

// Анімація - змінюємо кадр під час руху
animation_counter += 0.1;
if (animation_counter >= image_number)
{
	animation_counter = 0;
}
image_index = animation_counter;

// Атака крабу - збільшення урону та перевірка зіткнення з гравцем
attack_cooldown--;
if (instance_exists(obj_player))
{
	if (distance_to_object(obj_player) < 50 && attack_cooldown <= 0)
	{
		// Крабу можна атакувати гравця
		attack_cooldown = 30; // Затримка перед наступною атакою
	}
}

// Знищення при смерті
if (hp <= 0)
{
	instance_destroy(self);
}







