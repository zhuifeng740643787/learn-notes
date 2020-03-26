# 通信

## 同源策略
- 同源：协议+域名+端口
- 同源策略限制从一个源加载的文件或脚本如何与来自另一个源的资源进行交互，这是用来隔离潜在恶意文件的关键安全机制
- 同源策略限制的内容
    + Cookie、LocalStorage和IndexDB无法读取
    + DOM无法获得
    + AJAX请求不能发送

## 前后端如何通信
- Ajax: 受同源策略限制，兼容性好
- WebScoket: 不受同源策略限制，不支持IE
- CORS: 支持跨域通信，也支持同源通信,IE>=10

## 如何创建Ajax

```javascript
var ajaxJson = function (option) {
  if (!option.url) {
    return;
  }
  var url = option.url
  var method = option.method ? option.method : (option.type ? option.type : 'GET');
  method = method.toUpperCase()
  var xhr = typeof XMLHttpRequest !== 'undefined' ? new XMLHttpRequest() : new window.ActiveXObject('Microsoft.XMLHTTP') // 兼容IE
  var data = option.data ? option.data : {}
  var dataArr = []
  for (var k in data) {
    dataArr.push(k + '=' + data[k])
  }
  var async = typeof option.async === 'undefined' ? true : option.async
  if (method == 'GET') {
    url = url.includes('?') ? url : (dataArr.length > 0 ? (url + '?' + dataArr.join('&')) : url)
    xhr.open(url, method, async)
    xhr.send()
  }

  if (method == 'POST') {
    xhr.open(url, method, async)
    xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded')
    xhr.send(dataArr.join('&'))
  }

  xhr.onload = function () {
    var res = xhr.responseText
    if (xhr.status === 200 || xhr.status === 304) {
      if (option.success && option.success instanceof Function) {
        if (typeof res === 'string') {
          res = JSON.parse(res)
          option.success.call(xhr, res)
        }
      }
    } else {
      if (option.error && option.error instanceof Function) {
        option.error.call(xhr, res)
      }
    }
  }
}
```

## 跨域通信的几种方式
- JSONP: 
    + 原理：带有`src`属性的标签（如script、img、iframe）不受同源策略的限制，因此，可以通过向页面中动态添加`scirpt`标签来完成对跨域资源的访问
    + 优点：兼容性很好
    + 缺点：
        1. 只能GET不能POST,因为是通过scirpt引用的资源，参数全部放在URL中，和ajax毫无关系
        2. 存在安全隐患，动态插入script标签其实就是一种脚本注入（XSS）
- Hash: 
    + 原理：`#`后面的参数改变不会使页面刷新, 而search改变会使页面刷新
    + 场景是当前页面 A 通过iframe或frame嵌入了跨域页面 B,实现A与B的通信
- postMessage: 
    + h5中出现的跨域通信标准
    + 窗口A向跨域的窗口B发送信息
- WebScoket: IE不支持
- CORS: 
    + 需要浏览器（IE>=10）和服务器同时支持，整个通信过程，浏览器会自动完成
    + 一旦跨域，会在http头中添加origin字段，来说明本次请求来自哪个源，服务器端会返回头Access-Control-Allow-Origin字段来告诉浏览器该源是否在可访问名单中







  
