# 版本区别

## 5.6和5.7的区别

### group by 用法
[参考文档](https://blog.csdn.net/liufang1991/article/details/53034198)
在5.6及其以下可以使用`select * from(select * from table order by 排序字段) group by `字段，这种写法来得到分组需要的第一条记录，然而在5.7中**子查询的排序条件会被忽略掉**，暂时没有通过修改配置就可以解决的方案，只能参考demo自己改写sql语句
如下语句，其中from中子查询的`order by`语句在5.7版本中会被忽略掉，导致查询结果不一致：
```sql
SELECT *
  FROM (
    SELECT sku_id, last_sl_after AS tal_sl,id,FROM_UNIXTIME(dateline)
    FROM spkcb_lsz
    WHERE (ck_id = 3
      AND kw_id = 1 and goods_id=36
      AND dateline <= '1578579454')
     order by   dateline DESC
  ) s
  GROUP BY s.sku_id;
```
