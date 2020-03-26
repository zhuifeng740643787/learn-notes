# POST四种数据提交方式
[参考文献](https://imququ.com/post/four-ways-to-post-data-in-http.html '参考文献')

## application/x-www-form-urlencoded
- 最常见的 POST 提交数据的方式。浏览器的原生 <form> 表单，如果不设置 enctype 属性，那么最终就会以 
application/x-www-form-urlencoded 方式提交数据。请求类似于下面这样（无关的请求头在本文中都省略掉了）：
  ```
  POST http://www.example.com HTTP/1.1
  Content-Type: application/x-www-form-urlencoded;charset=utf-8

  title=test&sub%5B%5D=1&sub%5B%5D=2&sub%5B%5D=3
  ```
  首先，Content-Type 被指定为 application/x-www-form-urlencoded；其次，提交的数据按照 key1=val1&key2=val2 的方式进行编码，key 和 val 都进行了 URL 转码。

## multipart/form-data
  - 常见的POST数据提交方式，使用表单上传文件时，必须让form表单的enctype等于multipart/form-data，如下示例：
    ```
    POST http://www.example.com HTTP/1.1
    Content-Type:multipart/form-data; boundary=----WebKitFormBoundaryrGKCBY7qhFd3TrwA

    ------WebKitFormBoundaryrGKCBY7qhFd3TrwA
    Content-Disposition: form-data; name="text"

    title
    ------WebKitFormBoundaryrGKCBY7qhFd3TrwA
    Content-Disposition: form-data; name="file"; filename="chrome.png"
    Content-Type: image/png

    PNG ... content of chrome.png ...
    ------WebKitFormBoundaryrGKCBY7qhFd3TrwA--
    ```
    首先生成了一个 boundary 用于分割不同的字段，为了避免与正文内容重复，boundary 很长很复杂。然后 Content-Type 里指明了数据是以 multipart/form-data 来编码，本次请求的 boundary 是什么内容。消息主体里按照字段个数又分为多个结构类似的部分，每部分都是以 --boundary 开始，紧接着是内容描述信息，然后是回车，最后是字段具体内容（文本或二进制）。如果传输的是文件，还要包含文件名和文件类型信息。消息主体最后以 --boundary-- 标示结束

## application/json
  - 用来告诉服务端消息主体是序列化后的 JSON 字符串。由于 JSON 规范的流行，除了低版本 IE 之外的各大浏览器都原生支持 JSON.stringify，服务端语言也都有处理 JSON 的函数，使用 JSON 不会遇上什么麻烦。
  Google 的 AngularJS 中的 Ajax 功能，默认就是提交 JSON 字符串。例如下面这段代码：
    ```
    JS:
    var data = {'title':'test', 'sub' : [1,2,3]};
    $http.post(url, data).success(function(result) {
        ...
    });

    最终发送的请求是：
    BASH
    POST http://www.example.com HTTP/1.1 
    Content-Type: application/json;charset=utf-8

    {"title":"test","sub":[1,2,3]}
    ```

## text/xml
  - XML-RPC（XML Remote Procedure Call）, 它是一种使用 HTTP 作为传输协议，XML 作为编码方式的远程调用规范。典型的 XML-RPC 请求是这样的：
    ```
    HTML
    POST http://www.example.com HTTP/1.1 
    Content-Type: text/xml

    <?xml version="1.0"?>
    <methodCall>
        <methodName>examples.getStateName</methodName>
        <params>
            <param>
                <value><i4>41</i4></value>
            </param>
        </params>
    </methodCall>
    ```
    XML-RPC 协议简单、功能够用，各种语言的实现都有。它的使用也很广泛，如 WordPress 的 XML-RPC Api，搜索引擎的 ping 服务等等。JavaScript 中，也有现成的库支持以这种方式进行数据交互，能很好的支持已有的 XML-RPC 服务。XML 结构还是过于臃肿，一般场景用 JSON 会更灵活方便。
