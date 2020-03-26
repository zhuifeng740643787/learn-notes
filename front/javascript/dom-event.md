# DOM事件

## DOM事件级别
- DOM0: element.onclick = function(){}
- DOM1: 该标准未涉及事件
- DOM2: element.addEventListener('click', function(){}, false) // false代表冒泡阶段触发
- DOM3: element.addEventListener('keyup', function(){}, false) 增加了键盘/鼠标等交互事件

## DOM事件模型
- 捕获
- 冒泡

## DOM事件流
1. 捕获
2. 到达目标阶段
3. 冒泡 

## DOM事件捕获的具体流程
1. window
2. document
2. html(document.documentElement)
3. body
4. ...父元素
5. 目标元素

## Event对象的常见应用
- event.preventDefault(): 阻止默认事件
- event.stopPropagation(): 阻止冒泡行为
- event.stopImmediatePropagation(): 当有多个事件同时绑定到一个元素上时，可用来设置事件响应优先级，阻止其他的响应事件执行
- 事件代理对象：如点击父元素时，执行子元素的操作
    + event.currentTarget: 指父元素（当前绑定事件的元素）
    + event.target(event.sourceElement): 子元素(当前真正被点击的元素)

## 自定义事件
- Event: 只能指定事件名
- CustomEvent: 可指定事件名和参数
```javascript
<script>
  var newEve = new Event('custome')
  var newCustomEvent = new CustomEvent('customeEvent', {detail: {a:1, b:2}}) // 使用detail作为key值来传递数据
  var ele = document.body
  ele.addEventListener('custome', function(e) {
    console.log(e, 'custome')
  })
  ele.addEventListener('customeEvent', function(e) {
    console.log(e.detail, 'customeEvent')
  })
  ele.addEventListener('click', function(){
    ele.dispatchEvent(newEve) // 触发事件
    ele.dispatchEvent(newCustomEvent) // 触发事件
  })
</script>
```


