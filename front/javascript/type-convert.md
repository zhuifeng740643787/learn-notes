# 类型转换

## 类型
- 原始类型
    + Boolean
    + Null
    + Undefined
    + Number
    + String
    + Symbol
- 对象
    + Object

## 显示类型转化 
- Number()
    + 数值：转换后还是原来的值
    + 字符串：如果可以被解析为数值，则转换为相应数值，否则得到NaN，空字符串转换为0
    + 布尔值：true转为1，false转为0
    + undefined：转为NaN
    + null：转为0
    + 对象：
        1. 先调用自身的valueOf()方法，若该方法返回原始类型的值（数值、字符串和布尔值）,则直接对该值进行Number方法，不再进行后续步骤
        2. 若valueOf()方法返回复合类型的值，再调用对象自身的toString()方法，若返回原始类型的值，则对该值进行Number方法，不再进行后续操作
        3. 若toString()方法返回的是复合类型的值，则报错
- String()
    + 数值：转换为相应的字符串
    + 字符串：转换后还是原来的值
    + 布尔值：true转为"true"，false转为"false"
    + undefined：转为"undefined"
    + null：转为"null"
    + 对象：
        1. 先调用自身的toString()方法，若该方法返回原始类型的值（数值、字符串和布尔值）,则直接对该值进行String方法，不再进行后续步骤
        2. 若toString()方法返回复合类型的值，再调用对象自身的valueOf()方法，若返回原始类型的值，则对该值进行String方法，不再进行后续操作
        3. 若valueOf()方法返回的是复合类型的值，则报错
- Boolean函数
    + undefined、null、-0、+0、NaN、''： 全都转换为false
    + 其他的全都转换为true

## 隐式类型转换
- 四则运算
- 判断语句
- Native调用，如console.log、alert等



