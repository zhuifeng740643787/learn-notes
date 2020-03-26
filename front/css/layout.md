# 五种页面布局
- 绝对定位
- 浮动定位
- Flex布局
- Table布局
- Grid布局

## 各种布局的优缺点及兼容性
- 绝对定位： 快捷，但可使用性差（脱离了文档流，其子元素也脱离了文档流）
- 浮动定位：脱离了文档流，需要清除浮动，但兼容性好
- Flex布局：解决了上述两个布局方式的不足，主要适用于移动端，PC端兼容性不够好
- Table布局：兼容性很好，但其高度会随着子元素中最高元素的高度变化而变化
- Grid布局：最新布局规范，但兼容性差


## 实例
- 高度固定 100px，左右栏各300px，中间自适应
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>五种布局方式</title>
  <style type="text/css">
    *, *:before, *:after {
      margin: 0;
      padding: 0;
      -webkit-box-sizing: border-box;
      -moz-box-sizing: border-box;
      box-sizing: border-box;
    }
    .main {
      width: 100%;
    }
    .layout {
      width: 100%;
      min-height: 100px;
      margin-top: 20px;
    }
    .layout > article {
      width: 100%;
    }
    .layout > article > div {
      min-height: 100px;
    }
    .layout > article > div.left {
      background-color: #ff0000;
    }
    .layout > article > div.center {
      background-color: #00ff00;
    }
    .layout > article > div.right {
      background-color: #0000ff;
    }
  </style>
</head>
<body>
<section class="main">
  <section class="layout absolute">
    <style type="text/css" media="screen">
      .layout.absolute .left-center-right {
        position: relative;
      }
      .layout.absolute .left-center-right > div {
        position: absolute;
      }
      .layout.absolute .left-center-right .left {
        width: 300px;
        left: 0;
      }
      .layout.absolute .left-center-right .center {
        left: 300px;
        right: 300px;
      }
      .layout.absolute .left-center-right .right {
        width: 300px;
        right: 0;
      }
    </style>
    <article class="left-center-right">
      <div class="left"></div>
      <div class="center">
        <h2>绝对定位</h2>
        <p>内容</p>
        <p>内容</p>

      </div>
      <div class="right"></div>
    </article>
  </section>

  <section class="layout float">
    <style type="text/css" media="screen">
      .layout.float .left-center-right:after{
        display: table;
        content: '';
        width: 0;
        height: 0;
      }
      .layout.float .left-center-right .left {
        width: 300px;
        float: left;
      }
      .layout.float .left-center-right .right {
        width: 300px;
        float: right;
      }
    </style>
    <article class="left-center-right">
      <div class="left"></div>
      <div class="right"></div>
      <div class="center">
        <h2>浮动定位</h2>
        <p>内容</p>
        <p>内容</p>
        <p>内容</p><p>内容</p><p>内容</p><p>内容</p><p>内容</p><p>内容</p><p>内容</p>
      </div>
    </article>
  </section>

  <section class="layout flex">
    <style>
      .layout.flex .left-center-right {
        display: flex;
      }
      .layout.flex .left-center-right .left {
        width: 300px;
      }
      .layout.flex .left-center-right .center {
        flex: 1;
      }
      .layout.flex .left-center-right .right {
        width: 300px;
      }
    </style>
    <article class="left-center-right">
      <div class="left"></div>
      <div class="center">
        <h2>Flex布局</h2>
        <p>内容</p>
        <p>内容</p>
        <p>内容</p><p>内容</p><p>内容</p><p>内容</p><p>内容</p><p>内容</p><p>内容</p>
      </div>
      <div class="right"></div>
    </article>
  </section>

  <section class="layout table">
    <style>
      .layout.table .left-center-right {
        display: table;
      }
      .layout.table .left-center-right > div {
        display: table-cell;
      }
      .layout.table .left-center-right .left {
        width: 300px;
      }
      .layout.table .left-center-right .right {
        width: 300px;
      }
    </style>
    <article class="left-center-right">
      <div class="left"></div>
      <div class="center">
        <h2>Table布局</h2>
        <p>内容</p>
        <p>内容</p>
        <p>内容</p><p>内容</p><p>内容</p><p>内容</p><p>内容</p><p>内容</p><p>内容</p>
      </div>
      <div class="right"></div>
    </article>
  </section>

  <section class="layout grid">
    <style>
      .layout.grid .left-center-right {
        display: grid;
        grid-template-rows: 100px;
        grid-template-columns: 300px auto 300px;
      }
    </style>
    <article class="left-center-right">
      <div class="left"></div>
      <div class="center">
        <h2>Grid布局</h2>
        <p>内容</p>
        <p>内容</p>
        <p>内容</p><p>内容</p><p>内容</p><p>内容</p><p>内容</p><p>内容</p><p>内容</p>
      </div>
      <div class="right"></div>
    </article>
  </section>

</section>


</body>
</html>
```