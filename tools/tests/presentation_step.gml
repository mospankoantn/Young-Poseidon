tick++;
if(instance_exists(obj_player)) {obj_player.hp=20;obj_player.max_hp=20;}
if(stage==0 && tick>=5) {
    global.test_cutscene_advance=false;
    var _suffix=zone_index<7 ? "_1" : "_5";
    room_goto(asset_get_index("rm_"+zones[zone_index mod 7]+_suffix));
    stage=1;tick=0;exit;
}
if(stage==1) {
    if(tick==5 && zone_index<7) show_biome_cutscene(zones[zone_index]);
    if(tick==20 && zone_index<7) screenshot="biome-"+zones[zone_index]+".png";
    if(tick==22) global.test_cutscene_advance=true;
    if(tick==38) {
        check(!global.cutscene_active,"biome modal resumes "+room_get_name(room));
        check(audio_is_playing(global.zone_music_voice),"zone music "+room_get_name(room));
        if(zone_index mod 7 > 0) check(instance_number(obj_decor_base)>=12,"zone decorations "+room_get_name(room));
        screenshot="room-"+room_get_name(room)+".png";
    }
    if(tick==45) {
        zone_index++;
        if(zone_index<14) {stage=0;tick=0;}
        else {stage=2;tick=0;}
    }
    exit;
}
if(stage==2) {
    global.test_cutscene_advance=false;
    var _key=rewards[reward_index];
    if(_key=="intro") show_intro_cutscene();
    else if(_key=="outro") show_outro_cutscene();
    else show_weapon_cutscene(_key);
    check(instance_exists(obj_cutscene_screen),"scene opens "+_key);
    obj_cutscene_screen.close_action="resume";
    stage=3;tick=0;exit;
}
if(stage==3) {
    if(tick==20) screenshot="scene-"+rewards[reward_index]+".png";
    if(tick==22) global.test_cutscene_advance=true;
    if(tick==55) {
        check(!global.cutscene_active,"scene resumes "+rewards[reward_index]);
        reward_index++;
        if(reward_index>=array_length(rewards)) {
            check(true,"WORLD PRESENTATION TESTS");game_end();
        } else {stage=2;tick=0;}
    }
}
