/// @description Select visual state after the existing AI Step.
enemy_anim_update(spr_greek_warrior_idle, spr_greek_warrior_move,
    state == 1 || (state == 0 && patrol_timer <= 0));

