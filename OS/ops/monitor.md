# 监控

## 资源使用
- cpu
```
监控最占CPU的进程
# watch -n 1 "ps aux|sort -k 3 -rn |head"
当前cpu使用情况
# sar -u 1
```
- 内存
```
监控最占CPU的进程
# watch -n 1 "ps aux|sort -k 4 -rn |head"
当前内存使用情况
# sar -r 1
```
- tcp连接状态
```
# watch -n 1 "netstat -ant|head"
```


