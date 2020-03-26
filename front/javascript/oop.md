# 面向对象

## 类与实例
```javascript
// ES5中类的声明
function Animal() {
    this.name = 'name'
}
// ES6中类的声明
class Animal2() {
    constructor() {
        this.name = 'name'
    }
}

// 实例化
var animal = new Animal()
var animal2 = new Animal2()
```

## 类的继承方式
1. 借助构造函数实现继承
    - 改变父类构造函数的this指向，指向到子类的构造函数中去
    - 缺点：无法继承父类原型链对象上的方法
```javascript
  function Parent1() {
    this.name = 'parent1'
  }
  function Child1() {
    Parent1.call(this) // 改变Parent1的this指向当前子类的this
    this.type = 'child1'
  }

  Parent1.prototype.say = function() {
    return 'say'
  }
  console.log(new Child1().name)
//  console.log(new Child1().say()) // 会报错
```
2. 借助原型链实现继承
- 修改原型对象指向父类的实例
- 缺点：实例化之后的对象，一个改变，其他的也会跟着改变，因为指向了同一个对象
```javascript
  function Parent2() {
    this.name = 'parent2'
    this.data = [1,2,3]
  }
  function Child2() {
    this.type = 'child2'
  }
  Child2.prototype = new Parent2() // 修改原型对象指向Parent2的实例, 相当于new Child2().__proto__ = new Parent2()
  console.log(new Child2().name)
  var c1 = new Child2()
  var c2 = new Child2()
  c1.data.push(4)
  console.log(c1.data, c2.data) // [1, 2, 3, 4] [1, 2, 3, 4]
```

3. 组合构造函数和原型链实现继承
- 缺点：需要多次执行new父类的操作
```javascript
  function Parent3() {
    this.name = 'parent3'
    this.data = [1,2,3]
  }

  function Child3() {
    Parent3.call(this)
    this.type = 'child3'
  }

  Child3.prototype = new Parent3() // 子类原型对象指向父类的实例对象 一次new操作
  console.log(new Child3().name)
  var c1 = new Child3() // 一次new操作
  var c2 = new Child3() // 一次new操作
  c1.data.push(4)
  console.log(c1.data, c2.data) // [1, 2, 3, 4] [1, 2, 3]
```
4. 组合继承优化1
- 缺点：对象的构造函数指向到了父类
```javascript
  function Parent4() {
    this.name = 'parent4'
    this.data = [1,2,3]
  }

  function Child4() {
    Parent4.call(this)
    this.type = 'child4'
  }

  Child4.prototype = Parent4.prototype // 子类原型对象指向父类原型对象
  console.log(new Child4().name)
  var c1 = new Child4()
  var c2 = new Child4()
  c1.data.push(4)
  console.log(c1.data, c2.data) // [1, 2, 3, 4] [1, 2, 3]
  console.log(c1.constructor === Child4) // false
```
5. 组合继承优化2
```
  function Parent5() {
    this.name = 'parent5'
    this.data = [1,2,3]
  }

  function Child5() {
    Parent5.call(this)
    this.type = 'child5'
  }

  Child5.prototype = Object.create(Parent5.prototype) // 对原型对象进行隔离,子类原型对象的原型对象指向父类的原型对象
  Child5.prototype.constructor = Child5 // 构造函数指向Child5
  console.log(new Child5().name)
  var c1 = new Child5()
  var c2 = new Child5()
  c1.data.push(4)
  console.log(c1.data, c2.data) // [1, 2, 3, 4] [1, 2, 3]
  console.log(c1.constructor === Child5) // true
```

