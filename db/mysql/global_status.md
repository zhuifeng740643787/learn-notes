# 查看状态

## 命令
```
show global status;
```

## 各状态说明
- slow_queries  查看查询时间超过long_query_time秒的查询的个数
- slow_launch_threads 查看创建时间超过slow_launch_time秒的线程数
- max_used_connections 最大连接数, max_used_connections / max_connections * 100% （理想值 ≈ 85%）
- uptime 本次启动后的运行时间(单位：秒)
- com_select  select语句的执行数
- com_insert  查看insert语句的执行数
- com_update  查看update语句的执行数
- com_delete  查看delete语句的执行数
- connections 查看试图连接到mysql(不管是否连接成功)的连接数
- threads_cached 查看线程缓存内的线程的数量。
- threads_connected 查看当前打开的连接的数量。
- threads_created 查看创建用来处理连接的线程数。如果threads_created较大，你可能要增加thread_cache_size值。
- threads_running 查看激活的(非睡眠状态)线程数(当前并发数),这个数值一般远低于connected数值
- table_locks_immediate 查看立即获得的表的锁的次数。
- table_locks_waited 查看不能立即获得的表的锁的次数。如果该值较高，并且有性能问题，你应首先优化查询，然后拆分表或使用复制。
- created_tmp_disk_tables 磁盘上创建临时表的个数
- created_tmp_tables 创建临时表的个数  created_tmp_disk_tables / created_tmp_tables * 100% （理想值<= 25%），否则需要增加tmp_table_size
- created_tmp_files 创建的临时文件文件数
- open_tables 打开表的数
- opened_tables 打开过的表数量，数值过大，说明table_open_cache的设置过小
- open_files 文件打开数，open_files / open_files_limit * 100% （理想值<= 75％）
- qcache_free_blocks 缓存中相邻内存块的个数。数目大说明可能有碎片,flush query cache会对缓存中的碎片进行整理，从而得到一个空闲块
- qcache_free_memory 缓存中的空闲内存
- qcache_hits 每次查询在缓存中命中时就增大
- qcache_inserts 每次插入一个查询时就增大。命中次数除以插入次数就是不中比率
- qcache_lowmem_prunes 缓存出现内存不足并且必须要进行清理以便为更多查询提供空间的次数。这个数字最好长时间来看；如果这个数字在不断增长，就表示可能碎片非常严重，或者内存很少。（上面的free_blocks和free_memory可以告诉您属于哪种情况）
- qcache_not_cached 不适合进行缓存的查询的数量，通常是由于这些查询不是 select 语句或者用了now()之类的函数
- qcache_queries_in_cache 当前缓存的查询（和响应）的数量
- qcache_total_blocks 缓存中块的数量
- handler_read_rnd_next 表扫描次数，表扫描率 ＝ handler_read_rnd_next / com_select
如果表扫描率超过4000，说明进行了太多表扫描，很有可能索引没有建好，增加read_buffer_size值会有一些好处，但最好不要超过8mb。 
