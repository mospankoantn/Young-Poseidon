/// @description 
/// obj_trident Step Event

// Якщо гравця немає — нічого не робимо
if (!instance_exists(obj_player)) exit;
 
// ============================================================
// СТАН 1: ЗАСТРЯГ У СТІНІ
// Тризубець нерухомий, чекає команди повернення
// ============================================================
if (stuck)
{
    // Нічого не рухаємо, просто чекаємо
    exit;
}
 
// ============================================================
// СТАН 2: ЛЕТИТЬ
// ============================================================
if (thrown && !invisible_time)
{
    var _fly_dir = (image_xscale > 0) ? 0 : 180;
 
    // Рухаємо тризубець
    x += lengthdir_x(fly_speed, _fly_dir);
    y += lengthdir_y(fly_speed, _fly_dir);
 
    // Обертання для візуального ефекту
    image_angle = (image_xscale > 0) ? 0 : 180;
 
    timer++;
 
    // --- Зіткнення зі стіною ---
    if (place_meeting(x, y, obj_platform))
    {
        // Відступаємо назад щоб не провалитись у стіну
        x -= lengthdir_x(fly_speed, _fly_dir);
        y -= lengthdir_y(fly_speed, _fly_dir);
 
        stuck  = true;
        thrown = false;
        timer  = 0;
 
        // Створюємо платформу на місці застрягання
        var _plat        = instance_create_layer(x, y, "Instances", obj_trident_platform);
        _plat.image_xscale = image_xscale;
        exit;
    }
 
    // --- Зіткнення з ворогом ---
    var _hit = instance_place(x, y, obj_enemy);
    if (instance_exists(_hit))
    {
        with (_hit)
        {
            hp -= (other.damage + obj_player.temp_atk_buff);
        }
        thrown = false;
        timer  = 0;
        // Після влучання тризубець повертається до гравця
    }
 
    // --- Вихід за межі кімнати або час вийшов ---
    var _out = (x < -100 || x > room_width + 100
                || y < -100 || y > room_height + 100);
    if (_out || timer >= flight_duration)
    {
        thrown = false;
        timer  = 0;
    }
 
    exit;
}
 
// ============================================================
// СТАН 3: ПОВЕРНЕННЯ ДО ГРАВЦЯ
// (thrown=false, stuck=false)
// ============================================================
var _dist = point_distance(x, y, obj_player.x, obj_player.y);
 
if (_dist > fly_speed)
{
    // Летимо до гравця
    var _dir  = point_direction(x, y, obj_player.x, obj_player.y);
    x        += lengthdir_x(fly_speed, _dir);
    y        += lengthdir_y(fly_speed, _dir);
    image_angle = _dir;
}
else
{
    // Прийшли до гравця — "беремо в руки"
    x = obj_player.x;
    y = obj_player.y;
    image_angle           = 0;
    obj_player.trident_instance = self;
}