# 错误监控

## 前端错误的分类
- 即时运行错误: 代码错误
- 资源加载错误: 文件加载错误

## 错误的捕获方式
- 即时运行错误
    + try...catch...
    + window.onerror
- 资源加载错误
    + object.onerror
    + performance.getEntries(): 获取所有加载完成的资源
    + Error事件`捕获`: 资源加载错误只会捕获而不会冒泡
    ```javascript
        window.addEventListener('error', function(e){
            console.log('捕获', e)
        }, true)
    ```
- 跨域的js运行错误
    + 可以捕获
    + 错误提示：script error,不会显示出错行号和列号
    + 处理：
        1. 客户端：在script标签中增加`crossorigin`属性
        2. 服务端：设置js资源响应头Access-Control-Allow-Origin:*
        
## 上报错误的基本原理
- 采用Ajax通信方式上报(不常用)
- 利用Image对象上报(常用)
```
(new Image()).src = 'http://xxx?xx=xx';
```

