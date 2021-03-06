# http状态码
HTTP状态码（HTTP Status Code）是用以表示网页服务器超文本传输协议响应状态的3位数字代码。

## 1xx消息
这一类型的状态码，代表请求已被接受，需要继续处理。这类响应是临时响应，只包含状态行和某些可选的响应头信息，并以空行结束。<br/>
由于HTTP/1.0协议中没有定义任何1xx状态码，所以除非在某些试验条件下，服务器禁止向此类客户端发送1xx响应。这些状态码代表的响应都是信息性的，标示客户应该采取的其他行动。

| 状态码 | 说明 |
|:------|:-----|
|100 Continue | 服务器已经接收到请求头，并且客户端应继续发送请求主体，或者如果请求已经完成，忽略这个响应。|
|101 Switching Protocols| 服务器已经理解了客户端的请求，并将通过Upgrade消息头通知客户端采用不同的协议来完成这个请求。|
|102 Processing| 服务器已经收到并正在处理请求，但无响应可用。这样可以防止客户端超时，并假设请求丢失。|

## 2xx成功
这一类型的状态码，代表请求已成功被服务器接收、理解、并接受。

| 状态码 | 说明 |
|:------|:-----|
|200 OK | 请求已成功，请求所希望的响应头或数据体将随此响应返回。|
|201 Created |请求已经被实现，而且有一个新的资源已经依据请求的需要而创建，且其URI已经随Location头信息返回。 |
|202 Accepted | 服务器已接受请求，但尚未处理。最终该请求可能会也可能不会被执行，并且可能在处理发生时被禁止。|
|206 Partial Content| 服务器已经成功处理了部分GET请求。类似于FlashGet或者迅雷这类的HTTP 下载工具都是使用此类响应实现断点续传或者将一个大文档分解为多个下载段同时下载。|

## 3xx重定向
这类状态码代表需要客户端采取进一步的操作才能完成请求。通常，这些状态码用来重定向，后续的请求地址（重定向目标）在本次响应的Location域中指明。按照HTTP/1.0版规范的建议，浏览器不应自动访问超过5次的重定向。

| 状态码 | 说明 |
|:------|:-----|
|300 Multiple Choices|被请求的资源有一系列可供选择的回馈信息，每个都有自己特定的地址和浏览器驱动的商议信息。用户或浏览器能够自行选择一个首选的地址进行重定向。|
|301 Moved Permanently|被请求的资源已永久移动到新位置，并且将来任何对此资源的引用都应该使用本响应返回的若干个URI之一。如果可能，拥有链接编辑功能的客户端应当自动把请求的地址修改为从服务器反馈回来的地址。|
|302 Found|要求客户端执行**临时**重定向（原始描述短语为“Moved Temporarily”）。由于这样的重定向是临时的，客户端应当继续向原有地址发送以后的请求。只有在Cache-Control或Expires中进行了指定的情况下，这个响应才是可缓存的。|
|304 Not Modified |表示资源未被修改，因为请求头指定的版本If-Modified-Since或If-None-Match。在这种情况下，由于客户端仍然具有以前下载的副本，因此不需要重新传输资源。|

## 4xx客户端错误
这类的状态码代表了客户端看起来可能发生了错误，妨碍了服务器的处理。除非响应的是一个HEAD请求，否则服务器就应该返回一个解释当前错误状况的实体，以及这是临时的还是永久性的状况。


| 状态码 | 说明 |
|:------|:-----|
|400 Bad Request |由于明显的客户端错误（例如，格式错误的请求语法，太大的大小，无效的请求消息或欺骗性路由请求），服务器不能或不会处理该请求。|
|401 Unauthorized|类似于403 Forbidden，401语义即“未认证”，即用户没有必要的凭据|
|403 Forbidden|服务器已经理解请求，但是拒绝执行它。与401响应不同的是，身份验证并不能提供任何帮助，而且这个请求也不应该被重复提交。|
|404 Not Found|请求失败，请求所希望得到的资源未被在服务器上发现，但允许用户的后续请求。|
|405 Method Not Allowed|请求行中指定的请求方法不能被用于请求相应的资源。该响应必须返回一个Allow头信息用以表示出当前资源能够接受的请求方法的列表。|
|406 Not Acceptable|请求的资源的内容特性无法满足请求头中的条件，因而无法生成响应实体，该请求不可接受|
|408 Request Timeout|请求超时。根据HTTP规范，客户端没有在服务器预备等待的时间内完成一个请求的发送，客户端可以随时再次提交这一请求而无需进行任何更改。|
|409 Conflict|表示因为请求存在冲突无法处理该请求，例如多个同步更新之间的编辑冲突。|
|410 Gone|表示所请求的资源不再可用，将不再可用。|
|423 Locked|当前资源被锁定|

## 5xx服务器错误
表示服务器无法完成明显有效的请求。<br/>这类状态码代表了服务器在处理请求的过程中有错误或者异常状态发生，也有可能是服务器意识到以当前的软硬件资源无法完成对请求的处理。

| 状态码 | 说明 |
|:------|:-----|
|500 Internal Server Error|通用错误消息，服务器遇到了一个未曾预料的状况，导致了它无法完成对请求的处理。|
|502 Bad Gateway|作为网关或者代理工作的服务器尝试执行请求时，从上游服务器接收到无效的响应。|
|503 Service Unavailable|由于临时的服务器维护或者过载，服务器当前无法处理请求。这个状况是暂时的，并且将在一段时间以后恢复|
|504 Gateway Timeout|作为网关或者代理工作的服务器尝试执行请求时，未能及时从上游服务器（URI标识出的服务器，例如HTTP、FTP、LDAP）或者辅助服务器（例如DNS）收到响应。|






