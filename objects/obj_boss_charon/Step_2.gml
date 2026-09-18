/// @description Select visual state after the existing AI Step.
enemy_anim_update(spr_boss_charon_idle, spr_boss_charon_move,
    abs(x - anim_prev_x) > 0.1);

