if(instance_number(obj_debugger)>1) {instance_destroy();exit;}
report="__REPORT__";shots="__SHOTS__";screenshot="";
depth=-1000000;persistent=true;
tick=0;stage=0;zone_index=0;reward_index=0;
zones=["sea","coast","mines","hades","greece","battlefield","olympus"];
rewards=["intro","trident","spear","pickaxe","scythe","oar","sword","key","outro"];
global.test_cutscene_advance=false;
global.yp_settings.auto_pause=false;
global.yp_settings.hints=false;
world_state_reset();
check=function(_ok,_message) {
    var _f=file_text_open_append(report);
    file_text_write_string(_f,(_ok ? "PASS: " : "FAIL: ")+_message);
    file_text_writeln(_f);file_text_close(_f);
    if(!_ok) game_end();
};
