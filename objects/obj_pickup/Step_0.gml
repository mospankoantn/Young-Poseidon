/// @description Анімація підйому-опускання (необов'язково)
// obj_pickup Step Event

// Анімація "гойдання" вгору-вниз
image_yscale = 1 + sin(current_time / 400000 + bob_offset) * 0.12;
image_xscale = 1 + sin(current_time / 600000 + bob_offset) * 0.06;