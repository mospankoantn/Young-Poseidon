tick++;
if(tick>1800) {check(false,"fixture timeout");exit;}
if(stage==0 && room==rm_sea_1 && tick>3) {
    p=instance_create_layer(350,280,"Instances",obj_player);p.grv=0;p.max_hp=1000;p.hp=1000;
    with(obj_platform) instance_destroy();
    stage=1;tick=0;
}
if(stage==1) {
    if(index>=array_length(names)) {stage=4;tick=0;exit;}
    actor=instance_create_layer(p.x,p.y,"Instances",names[index]);
    if(variable_instance_exists(actor,"grv")) actor.grv=0;
    if(variable_instance_exists(actor,"boss_intro_shown")) actor.boss_intro_shown=true;
    actor.hp=100;actor.combat_last_hp=100;
    p.is_damage=false;p.alarm[0]=-1;p.hp=1000;p.hspd=0;p.vspd=0;
    check(enemy_take_hit(actor,1,p.x-30),"hit accepted: "+object_get_name(names[index]));
    check(!enemy_can_damage(actor),"immediate retaliation blocked");
    stage=2;tick=0;exit;
}
if(stage==2) {
    p.x=actor.x;p.y=actor.y;p.hspd=0;p.vspd=0;
    if(tick>=8) {
        check(p.hp==1000,"hurt contact and Step attack cause no damage");
        check(actor.hit_flash>0,"visible hit response active");
        actor.hp=0;p.is_damage=false;p.alarm[0]=-1;
        stage=3;tick=0;
    }
    exit;
}
if(stage==3) {
    if(instance_exists(actor)) {p.x=actor.x;p.y=actor.y;p.hspd=0;p.vspd=0;}
    if(tick>=10) {
        check(p.hp==1000,"death contact causes no damage");
        if(instance_exists(actor)) instance_destroy(actor);
        with(obj_charon_scythe) instance_destroy();with(obj_fallen_spirit) instance_destroy();with(obj_olympus_fire) instance_destroy();
        index++;stage=1;tick=0;
    }
    exit;
}
if(stage==4) {
    p.x=150;p.y=280;p.hp=1000;p.is_damage=false;p.hspd=0;p.vspd=0;p.grv=0.8;
    p.coyote_timer=5;global.test_jump=true;global.test_jump_held=true;
    with(p) event_perform(ev_step,ev_step_normal);
    check(p.vspd< -10,"coyote jump works after edge");
    global.test_jump=false;global.test_jump_held=false;
    with(p) event_perform(ev_step,ev_step_normal);
    check(p.vspd>=-5,"jump release controls height");
    p.move_velocity=20;p.jump_buffer=7;p.coyote_timer=5;p.attack_cooldown=5;
    p._reset_player_animation();
    check(p.move_velocity==0 && p.jump_buffer==0 && p.coyote_timer==0,"respawn/load clears buffered motion");
    p.vspd=0;p.grv=0;p.attack_cooldown=0;p.current_weapon=2;p.weapon_unlocked[2]=true;
    var _enemy=instance_create_layer(p.x+30,p.y,"Instances",obj_giant_crab);
    _enemy.hp=100;_enemy.grv=0;
    global.test_attack=true;
    with(p) event_perform(ev_step,ev_step_normal);
    var _after=_enemy.hp;
    with(p) event_perform(ev_step,ev_step_normal);
    check(_enemy.hp==_after,"melee cooldown prevents repeated frame damage");
    global.test_attack=false;instance_destroy(_enemy);
    var _source=instance_create_layer(600,300,"Instances",obj_boss_nymph);
    var _arrow=instance_create_layer(p.x,p.y-20,"Instances",obj_arrow);
    _arrow.source_enemy=_source;_source.hp=0;
    with(_arrow) event_perform(ev_step,ev_step_normal);
    check(!instance_exists(_arrow),"dead owner arrow removed before damage");
    instance_destroy(_source);
    var _debug=instance_create_layer(0,0,"Instances",obj_debugger);
    var _found=false;for(var _i=0;_i<array_length(_debug.room_list);_i++) if(_debug.room_list[_i][1]==rm_test) _found=true;
    check(_found,"debugger offers rm_test");instance_destroy(_debug);
    var _boss=instance_create_layer(750,280,"Instances",obj_boss_war_ghost);
    var _sp=instance_create_layer(800,280,"Instances",obj_fallen_spirit);_sp.summon_owner=_boss;
    var _hp=_boss.hp;instance_destroy(_sp);check(_boss.hp==_hp,"despawning living summon does not damage boss");
    _sp=instance_create_layer(800,280,"Instances",obj_fallen_spirit);_sp.summon_owner=_boss;_sp.hp=0;
    instance_destroy(_sp);check(_boss.hp==_hp-5,"killed owned summon damages boss once");instance_destroy(_boss);
    var _music=[snd_zone_sea,snd_zone_coast,snd_zone_mines,snd_zone_hades,snd_zone_greece,snd_zone_battlefield,snd_zone_olympus];
    for(var _m=0;_m<7;_m++) check(audio_exists(_music[_m]),"zone music registered "+string(_m));
    check(true,"PORTFOLIO COMBAT TESTS");game_end();
}
