# Javascript中apply、call、bind区别
[参考文档：https://www.cnblogs.com/coco1s/p/4833199.html](https://www.cnblogs.com/coco1s/p/4833199.html "妙用Javascript中apply、call、bind")


## apply、call

- 共同点

  在 javascript 中，call 和 apply 都是为了改变某个函数运行时的上下文（context）而存在的，换句话说，就是为了改变函数体内部 this 的指向。
  JavaScript 的一大特点是，函数存在「定义时上下文」和「运行时上下文」以及「上下文是可以改变的」这样的概念。

- 不同点

  对于 apply、call 二者而言，作用完全一样，只是接受参数的方式不太一样，call 需要把参数按顺序传递进去，而 apply 则是把参数放在数组里。　
  JavaScript 中，某个函数的参数数量是不固定的，因此要说适用条件的话，当你的参数是明确知道数量时用 call 。
  而不确定的时候用 apply，然后把参数 push 进数组传递进去。当参数数量不确定时，函数内部也可以通过 arguments 这个伪数组来遍历所有的参数。

## bind

  bind() 方法与 apply 和 call 很相似，也是可以改变函数体内 this 的指向。
  bind()方法会创建一个新函数，称为绑定函数，当调用这个绑定函数时，绑定函数会以创建它时传入 bind()方法的第一个参数作为 this，传入 bind() 方法的第二个以及以后的参数加上绑定函数运行时本身的参数按照顺序作为原函数的参数来调用原函数。

## apply、call、bind比较

- 当你希望改变上下文环境之后并非立即执行，而是回调执行的时候，使用 bind() 方法。而 apply/call 则会立即执行函数

## 总结

- apply 、 call 、bind 三者都是用来改变函数的this对象的指向的；
- apply 、 call 、bind 三者第一个参数都是this要指向的对象，也就是想指定的上下文；
- apply 、 call 、bind 三者都可以利用后续参数传参；
- bind 是返回对应函数，便于稍后调用；apply 、call 则是立即调用 。
