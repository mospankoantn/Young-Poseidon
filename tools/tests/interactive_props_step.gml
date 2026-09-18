tick++;
if(tick==20){
    for(var _weapon=0;_weapon<2;_weapon++) for(var _side=-1;_side<=1;_side+=2){
        p.x=300;p.y=300;p.vspd=0;p.l_right=_side>0;p.current_weapon=_weapon;p.weapon_unlocked[_weapon]=true;
        t.thrown=false;t.stuck=false;t.x=p.x;t.y=p.y;
        global.test_attack_pressed=true;
        with(p) event_perform(ev_step,ev_step_normal);
        global.test_attack_pressed=false;
        check(t.thrown && t.y<p.bbox_bottom-24,"weapon launches above feet "+string(_weapon)+"/"+string(_side));
        with(t) repeat(5) event_perform(ev_step,ev_step_normal);
        check(t.thrown && !t.stuck && t.bbox_bottom<300,"weapon clears ground "+string(_weapon)+"/"+string(_side));
        check(t.image_angle==0,"projectile mask is not double rotated");
    }
    t.thrown=false;t.stuck=false;
    var _boss=instance_create_layer(100,160,"Instances",obj_boss_triton);
    _boss.boss_intro_shown=true;_boss.fly_speed=0;
    var _r1=instance_create_layer(100,30,"Instances",obj_falling_rocks);
    var _r2=instance_create_layer(200,30,"Instances",obj_falling_rocks);
    var _b1=instance_create_layer(650,236,"Instances",obj_interactive_button);
    var _b2=instance_create_layer(740,236,"Instances",obj_interactive_button);
    check(_b1.press_button(),"button starts first rock");
    check(_r1.state==1 && _r2.state==0,"one rock at a time");
    check(!_b2.press_button() && !_b2.is_pressed,"busy button is not consumed");
    with(_r1) repeat(100) event_perform(ev_step,ev_step_normal);
    check(_boss.hp==40 && _r1.hit_boss,"falling rock hits Triton exactly once");
    check(_r1.state==2 && !_r1.solid && !object_is_ancestor(_r1.object_index,obj_platform),"landed rubble cannot block exit");
    with(_r1) repeat(200) event_perform(ev_step,ev_step_normal);
    check(_r1.state==3 && _r1.image_alpha==0,"spent rock disappears");
    check(_b2.press_button() && _r2.state==1,"next button launches next rock");
    with(_r2) repeat(400) event_perform(ev_step,ev_step_normal);
    p.weapon_unlocked[0]=false;_boss.x=600;_boss.y=0;
    with(_boss) repeat(182) event_perform(ev_step,ev_step_normal);
    check(_r1.state==0 && _r2.state==0 && !_r1.hit_boss,"wave recharges without a softlock");
    with(obj_falling_rocks) instance_destroy();instance_destroy(_boss);
    instance_destroy(_b1);instance_destroy(_b2);
    var _stone=instance_create_layer(100,100,"Instances",obj_falling_stone);
    with(_stone) repeat(400) {if(instance_exists(id)) event_perform(ev_step,ev_step_normal);}
    check(!instance_exists(_stone),"stalactite debris expires");

    p.x=470;p.y=300;p.current_weapon=3;p.hp=5;
    var _thicket=instance_create_layer(450,300,"Instances",obj_thicket_platform);
    global.test_attack_pressed=true;with(_thicket) event_perform(ev_step,ev_step_normal);global.test_attack_pressed=false;
    check(_thicket.is_cutting && _thicket.mask_index==-1 && _thicket.sprite_index==-1,"cut thicket immediately releases collision");
    with(_thicket) repeat(21) {if(instance_exists(id)) event_perform(ev_step,ev_step_normal);}
    check(!instance_exists(_thicket),"thicket fade completes");

    p.x=520;p.y=300;
    var _door=instance_create_layer(500,236,"Instances",obj_olympus_door);
    p.has_olympus_key=false;global.test_attack_pressed=true;
    with(_door) event_perform(ev_step,ev_step_normal);
    check(!_door.is_open,"door requires Olympus key");
    p.has_olympus_key=true;with(_door) repeat(31) event_perform(ev_step,ev_step_normal);
    global.test_attack_pressed=false;
    check(_door.is_open && _door.sprite_index==-1 && _door.mask_index==-1,"open door releases collision");
    instance_destroy(_door);

    var _stal=instance_create_layer(600,210,"Instances",obj_stalactite);
    p.x=620;p.y=280;p.current_weapon=2;
    repeat(4){_stal.hit_cd=0;global.test_attack_pressed=true;with(_stal) event_perform(ev_step,ev_step_normal);}
    global.test_attack_pressed=false;
    check(_stal.stones_left==0 && instance_number(obj_falling_stone)==4,"stalactite gives four stones");
    with(_stal) event_perform(ev_step,ev_step_normal);
    check(!instance_exists(_stal),"exhausted stalactite removed");
    with(obj_falling_stone) instance_destroy();

    var _cart=instance_create_layer(300,236,"Instances",obj_mine_cart);
    p.x=332;p.y=260;p.current_weapon=-1;
    check(_cart._enter_cart() && p.riding_cart==_cart,"enter cart");
    var _before_y=p.y;with(p) event_perform(ev_step,ev_step_normal);
    check(p.y==_before_y && _cart.has_player,"player physics suspended only while riding");
    _cart.cart_spd=4;with(_cart) event_perform(ev_step,ev_step_normal);
    check(abs(p.x-(_cart.bbox_left+_cart.bbox_right)/2)<0.01,"cart carries rider");
    check(_cart._exit_cart() && p.riding_cart==noone,"safe cart exit");
    instance_destroy(_cart);

    var _raft=instance_create_layer(400,190,"Instances",obj_raft);
    p.x=450;p.y=190;p.vspd=0;p.drop_timer=0;p.current_weapon=4;
    var _old_x=p.x,_raft_x=_raft.x;
    _raft.raft_spd=3;with(_raft) event_perform(ev_step,ev_step_normal);
    check(_raft.has_player && abs((p.x-_old_x)-(_raft.x-_raft_x))<0.01,"raft carries player by actual displacement");
    check(abs(p.bbox_bottom-(_raft.bbox_top-1))<1,"raft preserves feet alignment");
    var _aligned=true;
    repeat(240){
        with(_raft) event_perform(ev_step,ev_step_normal);
        _aligned=_aligned && _raft.has_player && abs(p.bbox_bottom-(_raft.bbox_top-1))<1;
    }
    check(_aligned,"raft stays aligned through a full bobbing cycle");
    p.y-=60;var _air_y=p.y;
    with(_raft) event_perform(ev_step,ev_step_normal);
    check(!_raft.has_player && p.y==_air_y,"raft does not pull airborne player");
    instance_destroy(_raft);
    with(obj_player) instance_destroy();with(obj_trident) instance_destroy();instance_destroy(floor_instance);
    gallery=true;
}
if(tick==24){check(true,"interactive props");game_end();}
