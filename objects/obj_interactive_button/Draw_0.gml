draw_self();
if(!prop_player_near(interact_range) || prop_nearest_button()!=id) exit;
var _text="["+yp_key_name("E")+"] "+yp_text("Скинути камінь","Drop rock");
var _color=make_color_rgb(245,208,113);
if(target_object==obj_falling_rocks) {
    if(instance_exists(obj_boss_triton)) {
        var _boss=obj_boss_triton;
        if(_boss.hp<=0) _text=yp_text("Тритона переможено","Triton defeated");
        else if(_boss.rock_recharge_timer>0)
            _text=yp_text("Відновлення: ","Recharging: ")+string(ceil(_boss.rock_recharge_timer/room_speed));
        else if(_boss._triton_has_falling_rock()) _text=yp_text("Камінь падає","Rock falling");
        else {
            var _left=0;with(obj_falling_rocks) if(state==0) _left++;
            _text+=" ("+string(_left)+")";
        }
    } else _text=yp_text("Немає каменів для запуску","No active rock mechanism");
}
else _text="["+yp_key_name("E")+"] "+yp_text("Активувати","Activate");
if(is_pressed) _color=make_color_rgb(98,211,191);
prop_hint(_text,_color);
