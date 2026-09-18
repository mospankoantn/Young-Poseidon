report_path="__REPORT__";tick=0;gallery=false;
global.load_pending=false;global.test_attack_pressed=false;global.test_recall_pressed=false;
check=function(_ok,_message){
    var _f=file_text_open_append(report_path);
    file_text_write_string(_f,(_ok?"PASS: ":"FAIL: ")+_message);file_text_writeln(_f);file_text_close(_f);
    if(!_ok) game_end();
};
p=instance_create_layer(300,300,"Instances",obj_player);p.grv=0;p.vspd=0;
floor_instance=instance_create_layer(0,300,"Instances",obj_platform);floor_instance.image_xscale=10;
t=instance_create_layer(p.x,p.y,"Instances",obj_trident);p.trident_instance=t;
