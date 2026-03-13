/// @description Анімація підйому-опускання (необов'язково)
// obj_pickup Step Event

image_yscale = 1 + sin(get_timer()/200000) * 0.1; // Проста анімація