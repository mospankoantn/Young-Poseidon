persistent = true;
report_path = "__REPORT__";
global.load_pending = false;
hero = instance_create_layer(100, 300, "Instances", obj_player);
hero.grv = 0;
hero.hp = 1000;
hero.max_hp = 1000;
hero.is_damage = true;
names = [
    "giant_crab", "harpy_seagull", "miner_spirit", "hades_shadow",
    "greek_warrior", "fallen_spirit", "olympus_fire",
    "boss_triton", "boss_nymph", "boss_uranus", "boss_charon",
    "boss_minotaur", "boss_war_ghost", "boss_moirai"
];
index = 0;
phase = 0;
ticks = 0;
current = noone;
seen = array_create(4, false);
previous_frame = -1;
fail = function(message)
{
    var f = file_text_open_write(report_path);
    file_text_write_string(f, "FAIL " + names[index] + ": " + message);
    file_text_close(f);
    game_end();
};

