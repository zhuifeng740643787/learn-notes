# CSS盒模型

## 模型分类
- 标准模型: 
    + 区别: content不包括border和padding 
    + 设置: box-sizong: content-box
- IE模型: 
    + 区别: content包括border和padding
    + 设置: box-sizing: border-box

## 获取宽高的方式
- dom.style.width/height : 只能取内联设置的style
- dom.currentStyle.width/height: 只支持IE
- window.getComputedStyle(dom).width/height:兼容性更好
- dom.getBoundingClientRect().width/height: 获取元素相对视窗的绝对位置和宽高

## 边距重叠问题
- 父子元素间、兄弟元素间垂直边距重叠

## 浮动
- 最初设计只是用来实现文字环绕排版的
- 三个特点
    + 脱离文档流
    + 向左/右浮动直到遇到父元素或者别的浮动元素
    + 会导致父元素高度坍塌
- 清除浮动写法
    + clear属性：不允许被清除浮动的元素的左边/右边挨着浮动元素，底层原理是在被清除浮动的元素上边或者下边添加足够的清除空间
    ```css
    // 全浏览器通用的clearfix方案【推荐】
    // 引入了zoom以支持IE6/7
    // 同时加入:before以解决现代浏览器上边距折叠的问题
    .clearfix:before,
    .clearfix:after {
      display: table;
      content: ' ';
    }
    .clearfix:after {
      clear: both;
    }
    .clearfix {
      *zoom: 1;// 用来支持IE6/7
    }
    ```


## BFC
- 概念: 块级格式化上下文
- 原理：
    + 同一个BFC容器下垂直方向的外边距会发生重叠（使用数值大的进行计算）
    + BFC的区域不会与浮动元素重叠，即阻止浮动元素被浮动元素覆盖，可用于清除浮动
    + BFC是一个独立的容器，外面的元素不会影响里面的元素，反之，里面的元素也不会影响外面的元素
    + 计算BFC高度时，浮动元素也会参与计算，即可以包含浮动元素
- 如何触发BFC:
    + body根元素
    + 浮动元素：float 除 none 以外的值
    + 绝对定位：position 为 absolute/fixed
    + display 为 inline-block/table-cell/flex
    + overflow 除 visible 以外的值（hidden/auto/scroll）
- 使用场景:
    + 解决垂直边距重叠问题
    + 清除浮动


