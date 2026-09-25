persistent=true;
report_path="__REPORT__";
global.load_pending=false;
global.test_jump=false;global.test_jump_held=false;global.test_right=false;global.test_attack=false;
global.cutscene_active=false;
world_state_reset();
names=[obj_giant_crab,obj_harpy_seagull,obj_miner_spirit,obj_hades_shadow,obj_greek_warrior,obj_fallen_spirit,
    obj_olympus_fire,obj_boss_triton,obj_boss_nymph,obj_boss_uranus,obj_boss_charon,obj_boss_minotaur,obj_boss_war_ghost,obj_boss_moirai];
stage=0;tick=0;actor=noone;index=0;p=noone;
check=function(_ok,_msg) {
    var _f=file_text_open_append(report_path);file_text_write_string(_f,(_ok?"PASS: ":"FAIL: ")+_msg);
    file_text_writeln(_f);file_text_close(_f);if(!_ok) game_end();
};
room_goto(rm_sea_1);
