var _dt = min(delta_time * 0.000001, 0.05);
age += _dt;
x += drift * _dt;
if (x > room_width + 32) x = -32;
y = home_y + sin(age * 1.3 + phase) * (zone == "coast" ? 14 : 6);
if (ambient_source) {
    ambient_timer--;
    if (ambient_timer <= 0) {
        var _sound = "wind";
        switch(zone) {
            case "coast": _sound="water"; break;
            case "mines": _sound="drip"; break;
            case "hades": _sound="wisp"; break;
            case "battlefield": _sound="fire"; break;
        }
        yp_sfx(_sound,x);
        ambient_timer = room_speed * irandom_range(7,14);
    }
}
