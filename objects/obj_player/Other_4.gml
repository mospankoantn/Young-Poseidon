/// @description Ініціалізація тризубця при входу в кімнату

// Якщо тризубець ще не знайдений, знаходимо його
if (trident_instance == noone || !instance_exists(trident_instance))
{
	trident_instance = instance_find(obj_trident, 0);
	if (!instance_exists(trident_instance))
	{
		// Якщо немає тризубця, створюємо його
		trident_instance = instance_create_layer(x + 30, y, "Instances", obj_trident);
	}
}
