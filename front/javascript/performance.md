# 页面性能

## 提升页面性能的方法

### 资源压缩合并，减少HTTP请求

### 非核心代码异步加载
- 异步加载的方式
    + 动态脚本加载：document.createElement('xxx')
    + defer
    + async
- 异步加载的区别
    + defer是在html解析完之后才会执行，如果是多个，按照加载顺序依次执行
    + async是在加载完之后立即执行，如果是多个，执行顺序和加载顺序无关

### 使用浏览器缓存
- 缓存优先级：Pragma > Cache-Control > Expires
- 强制缓存
    + Expires: xxx GMT（客户端时间，格林威治时间）
    + Cache-Control: max-age=3600 (相对时间，缓存时长(秒)) 
- 协商缓存 
    + Last-Modified(客户端请求后，服务端返回)/If-Modified-Since(客户端请求时，加入header): xxx GMT
    + Etag(客户端请求后，服务端返回)/If-None-Match(客户端请求时，加入header): 文件指纹标识符
    
### 使用CDN

### 预解析DNS
- 强制打开`a`标签的DNS预解析，http默认是打开的，https默认关闭
```
<meta http-equiv="x-dns-prefetch-control" content="on">
```
- 预解析
```
<link rel="dns-prefetch" href="//host_name_to_prefetch.com">
```