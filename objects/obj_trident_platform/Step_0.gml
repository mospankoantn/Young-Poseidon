/// @description 

var _interaction_button = ord("1");

if (!instance_exists(obj_player)) exit;
var _trident = instance_find(obj_trident, 0);
if (!instance_exists(_trident)) exit;

if (keyboard_check_pressed(_interaction_button))
{
	// Просто активируем тризубец
	_trident.invisible_time = true;
	_trident.thrown = false;
	_trident.stuck = false;
	_trident.alarm[0] = 15;
	_trident.image_angle = 0;
	
	obj_player.trident_instance = _trident;
	
	instance_destroy(self);	
}






