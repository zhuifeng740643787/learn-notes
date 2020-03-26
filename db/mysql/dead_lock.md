# 死锁

## 场景
1. 在同一事务内先后对同一条数据进行插入和更新操作； 
2. 多台服务器操作同一数据库； 
3. 瞬时出现高并发现象；
```
异常信息：
 Lock wait timeout exceeded; try restarting transaction
```

## 