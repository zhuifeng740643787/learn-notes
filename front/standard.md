# 规范

## JS
- 缩进
    + 代码缩进为*2*个空格，不是一个*tab*，更不是*4*个空格
    + 代码缩进为*2*个空格，不是一个*tab*，更不是*4*个空格
    + 代码缩进为*2*个空格，不是一个*tab*，更不是*4*个空格
- 空行
    + 最多允许连续两行
- 分号
    + 语句末尾**不使用**分号
- 变量命名
    + 使用*驼峰式**
- 函数命名 
    + 使用*驼峰式**
    + 构造函数首字母要*大写*
- BOM
    + 不要使用 **windows** 的记事本改代码！

- 例子
```js
  // 一个int型变量
  var aInt = 123, bInt = 234
  // 函数定义
  function sum (a, b) {
    return a + b
  }
  console.log(sum(aInt, bInt))

  // 一个string型变量, 用单引号包含,
  var aStr = 'abcd'
  console.log('aStr的长度为:' + aStr.length)
  // 一个数组型变量
  var aArr = [1, 2, "aaa"]
  // 遍历数组
  aArr.forEach(function (item, index) {
    console.log('aArr[' + index + '] = ' + item)
  })
  // 一个对象
  var aObj = {
    d1: 'dd',
    d2: 'dddd',
  }
  // 打印对象属性的两种方法
  console.log(aObj.d1, aObj['d1'])
  // 遍历对象
  Object.keys(function (key) {
    console.log('aObj.' + key + ' = ', aObj[key])
  })

  // 构造函数
  function Person (name, gender) {
    this.name = name
    this.gender = gender
  }
  // 原型链方法
  Person.prototype.sayHello = function () {
    console.log('Hello, my name is ' + this.name + '!')
  }

  var person = new Person('Foo', 'male')
  // 调用对象的函数，函数调用时，禁止使用空格
  person.sayHello()
  if (person.gender === 'male') {
    console.log("Handsome!")
  } else {
  console.log("Beautiful!")

```

## Html
- DOCTYPE声明
    + HTML文件必须加上 DOCTYPE 声明，并统一使用 HTML5 的文档声明 `<!DOCTYPE html>`
- 字符设置
    + 统一 `<meta charset="UTF-8">`
- 大小写
    + HTML标签名、类名、标签属性和大部分属性值统一用*小写*
- 类型属性
    + 不需要为 CSS、JS 指定类型属性，HTML5 中默认已包含
- 元素属性
    + 属性值使用双引号
- 缩进
    + 统一使用*2*个空格
- 代码嵌套
    + 每个块状元素独立一行，内联元素可选
- 例子
```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <!-- 设置字符集 -->
  <meta charset="UTF-8">
  <!-- 优先使用 IE 最新版本和 Chrome Frame -->
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
  <!-- 移动端自适应 -->
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, shrink-to-fit=no" >
  <link rel="stylesheet" href="xxxx/xxx.css" >
  <script src="xxxx/xx.js"></script>
</head>
<body>
  <header>
    <h1><span>Example</span></h1>
  </header>
  <section class="main">
    <input type="radio" name="name" checked="checked" >
    <a href="#">more&gt;&gt;</a>
  </section>
  <footer>
    <p><span>这是页面底部</span></p>
  </footer>
  <script src="xxxx/xxx.js"></script>
</body>
</html>
```
