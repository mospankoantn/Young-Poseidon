/// obj_olympus_filter — Create Event

// Сяяння
glow_offset = 0;
glow_speed  = 0.008;
 
// Іскри
spark_count = 40;
spark_x     = array_create(spark_count);
spark_y     = array_create(spark_count);
spark_vx    = array_create(spark_count);
spark_vy    = array_create(spark_count);
spark_life  = array_create(spark_count);
spark_maxl  = array_create(spark_count);
 
for (var _i = 0; _i < spark_count; _i++)
{
    spark_x[_i]    = random(1920);
    spark_y[_i]    = random(1080);
    spark_vx[_i]   = random_range(-0.5, 0.5);
    spark_vy[_i]   = random_range(-1.0, -0.2);
    spark_maxl[_i] = random_range(60, 180);
    spark_life[_i] = irandom(spark_maxl[_i]);
}
 
// Хмари
cloud_drift = 0;
ether_pulse = 0;