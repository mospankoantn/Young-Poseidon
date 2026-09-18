/// Dialogue timers do not advance during pause.
if (game_paused) exit;
if (player_dialog_timer>0) {
    player_dialog_timer--;
    player_dialog_alpha=lerp(player_dialog_alpha,1,0.15);
    if (yp_input("Q",true)) player_dialog_timer=0;
} else player_dialog_alpha=lerp(player_dialog_alpha,0,0.12);
if (npc_dialog_timer>0) {
    npc_dialog_timer--;
    npc_dialog_alpha=lerp(npc_dialog_alpha,1,0.15);
    if (yp_input("Q",true)) npc_dialog_timer=0;
} else npc_dialog_alpha=lerp(npc_dialog_alpha,0,0.12);
if (hint_timer>0) {
    hint_timer--;
    hint_alpha=lerp(hint_alpha,1,0.15);
} else hint_alpha=lerp(hint_alpha,0,0.1);
