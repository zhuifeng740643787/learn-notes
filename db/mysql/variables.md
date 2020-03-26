# 配置选项
```
show global variables;
```

## 选项
- query_cache_limit 超过此大小的查询将不缓存
- query_cache_min_res_unit：缓存块的最小大小 
- query_cache_size：查询缓存大小 
- query_cache_type：缓存类型，决定缓存什么样的查询，ON表示不缓存 select sql_no_cache 查询 
- query_cache_wlock_invalidate：当有其他客户端正在对MyISAM表进行写操作时，如果查询在query cache中，是否返回cache结果还是等写操作完成再读表获取结果。
- query_cache_min_res_unit的配置是一柄”双刃剑”，默认是4KB，
```
设置值大对大数据查询有好处，但如果你的查询都是小数据查询，就容易造成内存碎片和浪费。
查询缓存碎片率 = Qcache_free_blocks / Qcache_total_blocks * 100%
如果查询缓存碎片率超过20%，可以用FLUSH QUERY CACHE整理缓存碎片，或者试试减小query_cache_min_res_unit，如果你的查询都是小数据量的话。
查询缓存利用率 = (query_cache_size – Qcache_free_memory) / query_cache_size * 100%
查询缓存利用率在25%以下的话说明query_cache_size设置的过大，可适当减小；查询缓存利用率在80％以上而且Qcache_lowmem_prunes > 50的话说明query_cache_size可能有点小，要不就是碎片太多。
查询缓存命中率 = (Qcache_hits – Qcache_inserts) / Qcache_hits * 100%
示例服务器 查询缓存碎片率 ＝ 20.46％，查询缓存利用率 ＝ 62.26％，查询缓存命中率 ＝ 1.94％，命中率很差，可能写操作比较频繁吧，而且可能有些碎片。
```
