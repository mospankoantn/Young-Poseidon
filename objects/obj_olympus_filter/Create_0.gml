/// obj_olympus_filter — Create Event
/// Олімп: небесне сяйво, ефірні хмари, промені та золоті іскри.

fx_time = 0;

spark_count = 38;
spark_x     = array_create(spark_count);
spark_y     = array_create(spark_count);
spark_vx    = array_create(spark_count);
spark_vy    = array_create(spark_count);
spark_phase = array_create(spark_count);
spark_size  = array_create(spark_count);
for (var _i = 0; _i < spark_count; _i++)
{
    spark_x[_i]     = random(1);
    spark_y[_i]     = random(1);
    spark_vx[_i]    = random_range(-0.006, 0.006);
    spark_vy[_i]    = random_range(-0.022, -0.007);
    spark_phase[_i] = random(pi * 2);
    spark_size[_i]  = random_range(0.8, 1.8);
}
