tick++;
if(stage==0 && room==rm_sea_1 && tick>3){
    world_state_reset();
    p=instance_create_layer(120,300,"Instances",obj_player);
    p.grv=0;p.vspd=0;

    var _b=instance_create_layer(400,220,"Instances",obj_stone_boulder);
    var _bkey=world_state_instance_key(_b,"destroyed");
    world_state_mark_instance(_b,"destroyed");
    instance_destroy(_b);
    var _b2=instance_create_layer(400,220,"Instances",obj_stone_boulder);
    check(world_state_has(_bkey)&&!instance_exists(_b2),"destroyed obstacle stays removed");

    var _item=instance_create_layer(500,220,"Instances",obj_pickup_ambrosia);
    var _ikey=world_state_instance_key(_item,"pickup");
    world_state_mark_instance(_item,"pickup");
    instance_destroy(_item);
    var _item2=instance_create_layer(500,220,"Instances",obj_pickup_ambrosia);
    check(world_state_has(_ikey)&&!instance_exists(_item2),"unique pickup stays collected");

    var _door=instance_create_layer(600,220,"Instances",obj_olympus_door);
    with(_door) event_user(0);
    var _dkey=world_state_instance_key(_door,"opened");
    instance_destroy(_door);
    var _door2=instance_create_layer(600,220,"Instances",obj_olympus_door);
    check(world_state_has(_dkey)&&_door2.is_open&&_door2.mask_index==-1,"opened door state restores");
    instance_destroy(_door2);

    world_state_mark_boss_defeated("triton");
    var _boss=instance_create_layer(700,180,"Instances",obj_boss_triton);
    _boss.boss_intro_shown=true;
    with(_boss) event_perform(ev_step,ev_step_normal);
    check(!instance_exists(_boss)&&instance_exists(obj_pickup_trident_reward),"defeated boss restores uncollected reward");
    var _reward=instance_find(obj_pickup_trident_reward,0);
    _reward.can_pickup=true;
    with(_reward) event_user(0);
    check(world_state_has(world_state_reward_key("triton"))&&p.weapon_unlocked[0],"boss reward collection persists");
    check(global.weapon_unlocked[0],"boss reward synchronizes fallback weapon state");

    check(save_slot_status(0)==2,"boss reward creates a valid autosave in slot 0");
    check(save_game(1,false)&&save_slot_status(1)==2,"version 2 manual slot 1 validates");
    check(file_exists(_save_slot_file(1)),"atomic save creates slot 1 final file");
    check(save_game(2,false)&&save_slot_status(2)==2,"manual slot 2 validates independently");
    check(save_game(10,false)&&save_slot_status(10)==2,"manual slot 10 validates at the upper boundary");
    check(save_slot_room(10)==room,"save slot exposes its stored room for the slot menu");
    world_state_reset();
    stage=1;
    check(load_game(),"version 2 save starts loading");
    exit;
}
if(stage==1 && room==rm_sea_1 && tick>8){
    if(!instance_exists(obj_player)) p=instance_create_layer(120,300,"Instances",obj_player);
    apply_pending_load_to_player();
    check(world_state_has("boss|triton|defeated"),"boss state survives reload");
    check(world_state_has("reward|triton|collected"),"reward state survives reload");
    check(save_slot_status(0)==2&&save_slot_status(2)==2&&save_slot_status(10)==2,"loading slot 1 leaves autosave and other manual slots intact");

    var _before=variable_struct_get_names(global.world_state);
    write_test_save(2,"not_a_room",false);
    check(!load_game()&&array_length(variable_struct_get_names(global.world_state))==array_length(_before),"corrupt room is rejected without replacing state");
    check(save_slot_status(2)==2,"corrupt slot 1 does not damage slot 2");

    write_test_save(YP_SAVE_VERSION+1,"rm_sea_1",false);
    check(!load_game(),"newer save version is rejected");

    write_test_save(1,"rm_sea_1",true);
    stage=2;
    check(load_game(),"legacy version 1 save is accepted");
    exit;
}
if(stage==2 && room==rm_sea_1 && tick>13){
    if(!instance_exists(obj_player)) p=instance_create_layer(120,300,"Instances",obj_player);
    apply_pending_load_to_player();
    check(world_state_boss_defeated("triton"),"legacy weapon migrates to defeated boss");
    check(world_state_has(world_state_reward_key("triton")),"legacy weapon migrates to collected reward");
    check(p.weapon_unlocked[0],"legacy weapon remains unlocked");

    if(file_exists(YP_SAVE_LEGACY)) file_delete(YP_SAVE_LEGACY);
    file_copy(_save_slot_file(1),YP_SAVE_LEGACY);
    file_delete(_save_slot_file(1));
    check(save_slots_migrate_legacy()&&save_slot_status(1)==1,"legacy single save migrates into manual slot 1");
    check(file_exists(YP_SAVE_LEGACY),"legacy single save remains available after migration");

    world_state_mark("test|must_reset");
    stage=3;
    start_new_game();
    exit;
}
if(stage==3 && room==rm_sea_1 && tick>18){
    check(array_length(variable_struct_get_names(global.world_state))==0,"new game clears world state");
    var _none=true;
    for(var _i=0;_i<array_length(global.weapon_unlocked);_i++) _none=_none&&!global.weapon_unlocked[_i];
    check(_none,"new game and master fallback start without weapons");
    check(true,"WORLD STATE SAVE TESTS");
    game_end();
}
